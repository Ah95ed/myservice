/// خدمة تأمين المفاتيح السرية
/// يتم جلب المفاتيح من Firebase Remote Config
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SecureConfig {
  static FirebaseRemoteConfig? _remoteConfig;
  static bool _initialized = false;

  /// تهيئة الخدمة - يجب استدعاؤها في main()
  static Future<void> init() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // إعدادات المدة الزمنية
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // جلب وتفعيل القيم الأخيرة
      await _remoteConfig!.fetchAndActivate();
      _initialized = true;
    } catch (e) {
      print('❌ Error initializing SecureConfig: $e');
      rethrow;
    }
  }

  /// الحصول على Cloudflare Account ID
  static String get r2AccountId {
    _checkInitialized();
    return _remoteConfig?.getString('r2_account_id') ?? '';
  }

  /// الحصول على Cloudflare Endpoint
  static String get r2Endpoint {
    _checkInitialized();
    return _remoteConfig?.getString('r2_endpoint') ?? '';
  }

  /// الحصول على Cloudflare Access Key ID
  static String get r2AccessKeyId {
    _checkInitialized();
    return _remoteConfig?.getString('r2_access_key_id') ?? '';
  }

  /// الحصول على Cloudflare Secret Access Key
  static String get r2SecretAccessKey {
    _checkInitialized();
    return _remoteConfig?.getString('r2_secret_access_key') ?? '';
  }

  /// الحصول على Cloudflare Bucket Name
  static String get r2Bucket {
    _checkInitialized();
    return _remoteConfig?.getString('r2_bucket') ?? '';
  }

  /// التحقق من التهيئة
  static void _checkInitialized() {
    if (!_initialized) {
      throw Exception(
        '❌ SecureConfig not initialized! Call SecureConfig.init() first.',
      );
    }
  }

  /// إعادة تحميل البيانات من Firebase Remote Config
  static Future<void> refresh() async {
    try {
      await _remoteConfig?.fetchAndActivate();
    } catch (e) {
      print('⚠️ Error refreshing SecureConfig: $e');
    }
  }
}
