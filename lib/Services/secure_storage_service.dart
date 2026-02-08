/// خدمة التخزين الآمن للبيانات الحساسة
/// تستخدم flutter_secure_storage لتشفير البيانات
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // مفاتيح التخزين
  static const String _keyUserData = 'user_data';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserId = 'user_id';

  /// حفظ بيانات المستخدم بشكل آمن
  static Future<void> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String uid,
  }) async {
    try {
      final userData = {
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
        'savedAt': DateTime.now().toIso8601String(),
      };

      await _storage.write(key: _keyUserData, value: jsonEncode(userData));
      print('✅ User data saved securely');
    } catch (e) {
      print('❌ Error saving user data: $e');
      rethrow;
    }
  }

  /// استرجاع بيانات المستخدم
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final data = await _storage.read(key: _keyUserData);
      if (data != null) {
        return jsonDecode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error reading user data: $e');
      return null;
    }
  }

  /// حفظ التوكن
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyAuthToken, value: token);
      print('✅ Token saved securely');
    } catch (e) {
      print('❌ Error saving token: $e');
      rethrow;
    }
  }

  /// استرجاع التوكن
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyAuthToken);
    } catch (e) {
      print('❌ Error reading token: $e');
      return null;
    }
  }

  /// حفظ Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
      print('✅ Refresh token saved securely');
    } catch (e) {
      print('❌ Error saving refresh token: $e');
      rethrow;
    }
  }

  /// استرجاع Refresh Token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      print('❌ Error reading refresh token: $e');
      return null;
    }
  }

  /// حفظ بريد المستخدم
  static Future<void> saveUserEmail(String email) async {
    try {
      await _storage.write(key: _keyUserEmail, value: email);
    } catch (e) {
      print('❌ Error saving user email: $e');
    }
  }

  /// استرجاع بريد المستخدم
  static Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: _keyUserEmail);
    } catch (e) {
      print('❌ Error reading user email: $e');
      return null;
    }
  }

  /// حفظ معرف المستخدم
  static Future<void> saveUserId(String uid) async {
    try {
      await _storage.write(key: _keyUserId, value: uid);
    } catch (e) {
      print('❌ Error saving user ID: $e');
    }
  }

  /// استرجاع معرف المستخدم
  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _keyUserId);
    } catch (e) {
      print('❌ Error reading user ID: $e');
      return null;
    }
  }

  /// مسح جميع البيانات المحفوظة (عند تسجيل الخروج)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print('✅ All secure data cleared');
    } catch (e) {
      print('❌ Error clearing secure data: $e');
      rethrow;
    }
  }

  /// مسح بيانات معينة
  static Future<void> clearKey(String key) async {
    try {
      await _storage.delete(key: key);
      print('✅ Key cleared: $key');
    } catch (e) {
      print('❌ Error clearing key: $e');
      rethrow;
    }
  }

  /// التحقق من وجود مفتاح
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      print('❌ Error checking key: $e');
      return false;
    }
  }
}
