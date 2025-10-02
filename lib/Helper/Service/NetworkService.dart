import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Constant/AppConstants.dart';

// فئة لإدارة طلبات الشبكة
class NetworkService {
  static const Duration _timeout = Duration(seconds: 30);

  // GET request
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(AppConstants.networkError);
    } on HttpException {
      throw NetworkException('خطأ في الخادم');
    } catch (e) {
      throw NetworkException(AppConstants.unknownError);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(Uri.parse(url), headers: _getHeaders(), body: json.encode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(AppConstants.networkError);
    } on HttpException {
      throw NetworkException('خطأ في الخادم');
    } catch (e) {
      throw NetworkException(AppConstants.unknownError);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .put(Uri.parse(url), headers: _getHeaders(), body: json.encode(body))
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(AppConstants.networkError);
    } on HttpException {
      throw NetworkException('خطأ في الخادم');
    } catch (e) {
      throw NetworkException(AppConstants.unknownError);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _getHeaders())
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(AppConstants.networkError);
    } on HttpException {
      throw NetworkException('خطأ في الخادم');
    } catch (e) {
      throw NetworkException(AppConstants.unknownError);
    }
  }

  // الحصول على headers مشتركة
  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // معالجة الاستجابة
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      throw NetworkException(
        'خطأ ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }
}

// فئة للأخطاء المتعلقة بالشبكة
class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => message;
}
