import 'dart:convert';

import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_config.dart';
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class CloudflareApi {
  CloudflareApi._();

  static final CloudflareApi instance = CloudflareApi._();

  String get _baseUrl => CloudflareConfig.apiBaseUrl;

  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/reset-password'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
  }

  Future<bool> checkEmailExists(String email) async {
    final uri = Uri.parse(
      '$_baseUrl/auth/check-email',
    ).replace(queryParameters: {'email': email});
    final response = await http.get(uri);

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['exists'] == true;
  }

  Future<List<Map<String, dynamic>>> getCollection(
    String collection, {
    int page = 1,
    int limit = 50,
  }) async {
    final uri = _collectionUri(collection, page: page, limit: limit);
    final response = await http.get(uri);

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> addCollectionItem(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final uri = _collectionUri(collection);
    final headers = await _authHeaders();
    final body = _collectionPayload(collection, data);
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
  }

  Future<Map<String, dynamic>?> lookupByNumber(
    String collection,
    String number,
  ) async {
    final type = _collectionType(collection);
    if (type == null) {
      return null;
    }
    final uri = Uri.parse(
      '$_baseUrl/lookup',
    ).replace(queryParameters: {'type': type, 'number': number});
    final response = await http.get(uri);
    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['found'] == true) {
      return data;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getDonorsByNumber(String number) async {
    final uri = Uri.parse(
      '$_baseUrl/donors',
    ).replace(queryParameters: {'number': number});
    final response = await http.get(uri);
    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> deleteItem(String type, String id) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '$_baseUrl/items',
    ).replace(queryParameters: {'type': type, 'id': id});
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
  }

  Future<void> deleteUserByPhone(String phone) async {
    final headers = await _authHeaders();
    final uri = Uri.parse(
      '$_baseUrl/auth/by-phone',
    ).replace(queryParameters: {'phone': phone});
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
  }

  Future<Uri> requestAccountDeletionUrl() async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/account/delete-request'),
      headers: headers,
    );

    if (response.statusCode >= 400) {
      _logHttpError('POST', '$_baseUrl/account/delete-request', response);
      throw Exception(_parseError(response));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Missing delete URL');
    }
    return Uri.parse(url);
  }

  Future<void> submitEditRequest(
    Map<String, dynamic> payload,
    String phone,
  ) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/developer/requests'),
      headers: headers,
      body: jsonEncode({'phone': phone, 'data': payload}),
    );

    if (response.statusCode >= 400) {
      throw Exception(_parseError(response));
    }
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing auth token');
    }
    return {
      'content-type': 'application/json',
      'authorization': 'Bearer $token',
    };
  }

  Uri _collectionUri(String collection, {int page = 1, int limit = 50}) {
    if (_isBloodType(collection)) {
      return Uri.parse('$_baseUrl/donors').replace(
        queryParameters: {
          'bloodType': collection,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
    }

    switch (collection) {
      case 'Doctor':
        return Uri.parse('$_baseUrl/doctors').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
      case 'professions':
        return Uri.parse('$_baseUrl/professions').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
      case 'line':
        return Uri.parse('$_baseUrl/cars').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
      case 'Satota':
        return Uri.parse('$_baseUrl/satota').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
      default:
        return Uri.parse('$_baseUrl/$collection').replace(
          queryParameters: {'page': page.toString(), 'limit': limit.toString()},
        );
    }
  }

  Map<String, dynamic> _collectionPayload(
    String collection,
    Map<String, dynamic> data,
  ) {
    if (_isBloodType(collection)) {
      return {
        'name': data['name'],
        'phone': data['number'],
        'location': data['location'],
        'bloodType': collection,
      };
    }

    if (collection == 'Doctor') {
      return {
        'name': data['name'],
        'phone': data['number'],
        'specialization': data['specialization'],
        'presence': data['presence'],
        'title': data['title'],
      };
    }

    if (collection == 'professions') {
      return {
        'name': data['name'],
        'phone': data['number'],
        'nameProfession': data['nameProfession'],
      };
    }

    if (collection == 'line') {
      return {
        'name': data['name'],
        'phone': data['number'],
        'vehicleType': data['type'],
        'time': data['time'],
        'routeFrom': data['from'],
      };
    }

    if (collection == 'Satota') {
      return {
        'name': data['name'],
        'phone': data['number'],
        'location': data['location'],
      };
    }

    return data;
  }

  String? _collectionType(String collection) {
    if (_isBloodType(collection)) {
      return 'donor';
    }

    switch (collection) {
      case 'Doctor':
        return 'doctor';
      case 'professions':
        return 'profession';
      case 'line':
        return 'car';
      case 'Satota':
        return 'satota';
      default:
        return null;
    }
  }

  bool _isBloodType(String value) {
    return value == Constant.A_Plus ||
        value == Constant.A_Minus ||
        value == Constant.B_Plus ||
        value == Constant.B_Minus ||
        value == Constant.O_Plus ||
        value == Constant.O_Minus ||
        value == Constant.AB_Plus ||
        value == Constant.AB_Minus;
  }

  String _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final error = data['error']?.toString();
      if (error != null && error.isNotEmpty) {
        return 'Request failed (${response.statusCode}): $error';
      }
      return 'Request failed (${response.statusCode})';
    } catch (_) {
      final body = response.body.trim();
      if (body.isNotEmpty) {
        return 'Request failed (${response.statusCode}): $body';
      }
      return 'Request failed (${response.statusCode})';
    }
  }

  void _logHttpError(String method, String url, http.Response response) {
    final body = response.body.trim();
    Logger.logger(
      'HTTP $method $url failed: ${response.statusCode} ${response.reasonPhrase ?? ''} ${body.isEmpty ? '' : '| $body'}',
    );
  }
}
