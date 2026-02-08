/// خدمة تأمين المفاتيح السرية عبر Cloudflare Config
import 'dart:convert';

import 'package:Al_Zab_township_guide/Services/cloudflare_config.dart';
import 'package:http/http.dart' as http;

class SecureConfig {
  static bool _initialized = false;
  static Map<String, dynamic> _values = {};

  /// تهيئة الخدمة - يجب استدعاؤها في main()
  static Future<void> init() async {
    if (_initialized) return;

    try {
      await refresh();
      _initialized = true;
    } catch (e) {
      print('❌ Error initializing SecureConfig: $e');
      rethrow;
    }
  }

  /// الحصول على Cloudflare Account ID
  static String get r2AccountId => _getString('r2_account_id');

  /// الحصول على Cloudflare Endpoint
  static String get r2Endpoint => _getString('r2_endpoint');

  /// الحصول على Cloudflare Access Key ID
  static String get r2AccessKeyId => _getString('r2_access_key_id');

  /// الحصول على Cloudflare Secret Access Key
  static String get r2SecretAccessKey => _getString('r2_secret_access_key');

  /// الحصول على Cloudflare Bucket Name
  static String get r2Bucket => _getString('r2_bucket');

  /// رقم التحديث القادم للتطبيق
  static String get updateBuildNumber => _getString('update');

  /// التحقق من التهيئة
  static void _checkInitialized() {
    if (!_initialized) {
      throw Exception(
        '❌ SecureConfig not initialized! Call SecureConfig.init() first.',
      );
    }
  }

  static String _getString(String key) {
    _checkInitialized();
    final value = _values[key];
    if (value == null) return '';
    return value.toString();
  }

  /// إعادة تحميل البيانات من Cloudflare Config
  static Future<void> refresh() async {
    final endpoint = CloudflareConfig.configEndpoint;
    if (endpoint.isEmpty) {
      throw Exception('Missing Cloudflare config endpoint');
    }

    final headers = <String, String>{'content-type': 'application/json'};
    final token = CloudflareConfig.configToken;
    if (token.isNotEmpty) {
      headers['authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.get(Uri.parse(endpoint), headers: headers);
      if (response.statusCode >= 400) {
        throw Exception('Config request failed: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        _values = decoded;
      } else if (decoded is Map) {
        _values = Map<String, dynamic>.from(decoded);
      } else {
        throw Exception('Invalid config payload');
      }
    } catch (e) {
      print('⚠️ Error refreshing SecureConfig: $e');
      rethrow;
    }
  }
}
