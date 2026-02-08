# دليل الإصلاحات الأمنية الحرجة
## Critical Security Fixes Guide

⚠️ **تنبيه أمني عاجل:** يجب تطبيق هذه الإصلاحات فوراً

---

## 🔒 الإصلاح #1: تأمين مفاتيح Cloudflare R2

### الخطورة: 🔴🔴🔴 حرجة جداً

### المشكلة الحالية
ملف [lib/Service/r2_config.dart](lib/Service/r2_config.dart) يحتوي على مفاتيح سرية مكشوفة بالكامل.

### الإجراءات المطلوبة فوراً

#### الخطوة 1: تغيير المفاتيح الحالية
⚠️ **قبل أي شيء:** ادخل إلى لوحة Cloudflare وقم بـ:
1. إلغاء المفاتيح الحالية المكشوفة
2. إنشاء مفاتيح جديدة
3. عدم نشر المفاتيح الجديدة في Git

#### الخطوة 2: إضافة الملف إلى .gitignore
```bash
# في ملف .gitignore
lib/Service/r2_config.dart
```

#### الخطوة 3: إنشاء ملف مثال
```dart
// lib/Service/r2_config.example.dart
// هذا ملف مثال فقط - لا يحتوي على مفاتيح حقيقية
const String R2_ACCOUNT_ID = 'YOUR_ACCOUNT_ID_HERE';
const String R2_ENDPOINT = 'YOUR_ENDPOINT_HERE';
const String R2_ACCESS_KEY_ID = 'YOUR_ACCESS_KEY_HERE';
const String R2_SECRET_ACCESS_KEY = 'YOUR_SECRET_KEY_HERE';
const String R2_BUCKET = 'YOUR_BUCKET_NAME';
```

#### الخطوة 4: استخدام Firebase Remote Config (الحل الأمثل)

**أ. إعداد Firebase Remote Config:**

1. في Firebase Console:
   - اذهب إلى Remote Config
   - أضف المفاتيح التالية:
     ```
     r2_access_key_id
     r2_secret_access_key
     r2_endpoint
     r2_account_id
     r2_bucket
     ```

2. قم بتحديث الكود:

```dart
// lib/Service/secure_config.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SecureConfig {
  static FirebaseRemoteConfig? _remoteConfig;
  
  static Future<void> init() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await _remoteConfig!.fetchAndActivate();
  }
  
  static String get r2AccessKeyId => 
      _remoteConfig?.getString('r2_access_key_id') ?? '';
  
  static String get r2SecretAccessKey => 
      _remoteConfig?.getString('r2_secret_access_key') ?? '';
  
  static String get r2Endpoint => 
      _remoteConfig?.getString('r2_endpoint') ?? '';
  
  static String get r2AccountId => 
      _remoteConfig?.getString('r2_account_id') ?? '';
  
  static String get r2Bucket => 
      _remoteConfig?.getString('r2_bucket') ?? '';
}
```

3. تحديث main.dart:

```dart
Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      await WidgetsFlutterBinding.ensureInitialized();
      await init();
      
      // إضافة هذا السطر
      await SecureConfig.init();
      
      // ... بقية الكود
    },
    (error, stackTrace) {
      Logger.logger('error: $error || stackTrace: $stackTrace');
    },
  );
}
```

4. تحديث CloudflareR2Service:

```dart
// lib/Service/CloudflareR2Service.dart
import 'secure_config.dart';

class CloudflareR2Service {
  // استبدال cfg.R2_ACCESS_KEY_ID بـ SecureConfig.r2AccessKeyId
  // استبدال cfg.R2_SECRET_ACCESS_KEY بـ SecureConfig.r2SecretAccessKey
  // ... إلخ
  
  static Future<Uri> presignedGetUrl(String key, {int expiresIn = 300}) async {
    // ...
    final credential =
        '${SecureConfig.r2AccessKeyId}/$dateStamp/$region/$service/aws4_request';
    // ... بقية الكود
  }
}
```

---

## 🔐 الإصلاح #2: تشفير كلمات المرور

### الخطورة: 🔴🔴🔴 حرجة جداً

### المشكلة
كلمات المرور مخزنة بنص صريح في Firebase Realtime Database.

### الحل الموصى به: استخدام Firebase Authentication

#### الخطوة 1: تفعيل Firebase Authentication
1. في Firebase Console → Authentication
2. فعّل Email/Password authentication
3. فعّل Phone authentication (اختياري)

#### الخطوة 2: تحديث الكود

```dart
// lib/Services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // تسجيل مستخدم جديد
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // إنشاء المستخدم في Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // تحديث ملف المستخدم
      await userCredential.user?.updateDisplayName(name);
      
      // حفظ البيانات الإضافية في Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // تسجيل الدخول
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
    // مسح البيانات المحلية
    await shared?.clear();
  }
  
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      default:
        return 'حدث خطأ: ${e.message}';
    }
  }
}
```

#### الخطوة 3: تحديث LoginProvider

```dart
// lib/controller/provider/LoginProvider/Loginprovider.dart
import 'package:Al_Zab_township_guide/Services/auth_service.dart';

class LoginProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  Future<void> login(
    BuildContext context,
    String? email,
    String? password,
  ) async {
    if (email?.isEmpty ?? true) {
      setError('يرجى إدخال البريد الإلكتروني');
      return;
    }

    if (password?.isEmpty ?? true) {
      setError('يرجى إدخال كلمة المرور');
      return;
    }

    try {
      _setLoading(true);
      clearError();
      
      // استخدام Firebase Authentication
      UserCredential? userCredential = await _authService.signIn(
        email: email!,
        password: password!,
      );
      
      if (userCredential != null) {
        // حفظ معلومات المستخدم
        await shared!.setBool('isRegister', true);
        await shared!.setString('uid', userCredential.user!.uid);
        
        // الانتقال للشاشة الرئيسية
        Navigator.pushReplacementNamed(context, MainScreen.ROUTE);
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
```

---

## 🛡️ الإصلاح #3: تأمين البيانات المحلية

### إضافة flutter_secure_storage

#### الخطوة 1: إضافة الحزمة
```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

#### الخطوة 2: إنشاء SecureStorageService

```dart
// lib/Services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  // حفظ بيانات المستخدم
  static Future<void> saveUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    final userData = {
      'name': name,
      'email': email,
      'phone': phone,
    };
    
    await _storage.write(
      key: 'user_data',
      value: jsonEncode(userData),
    );
  }
  
  // استرجاع بيانات المستخدم
  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: 'user_data');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }
  
  // حفظ التوكن
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  // استرجاع التوكن
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  // مسح كل البيانات
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

#### الخطوة 3: استبدال SharedPreferences للبيانات الحساسة

```dart
// استبدال هذا:
await shared!.setString('nameUser', data['name']);
await shared!.setString('emailUser', data['email']);
await shared!.setString('phoneUser', data['phone']);

// بهذا:
await SecureStorageService.saveUserData(
  name: data['name'],
  email: data['email'],
  phone: data['phone'],
);
```

---

## 🔥 الإصلاح #4: قواعد أمان Firebase

### Realtime Database Rules

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "blood_donors": {
      ".read": "auth != null",
      "$donorId": {
        ".write": "auth != null && (!data.exists() || data.child('userId').val() === auth.uid)"
      }
    },
    "doctors": {
      ".read": "auth != null",
      "$doctorId": {
        ".write": "auth != null"
      }
    }
  }
}
```

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // قاعدة عامة: رفض كل شيء ما لم يُسمح به صراحة
    match /{document=**} {
      allow read, write: if false;
    }
    
    // بيانات المستخدمين
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // المتبرعين بالدم
    match /blood_donors/{donorId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
    
    // الأطباء
    match /doctors/{doctorId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## ✅ قائمة التحقق النهائية

- [ ] تم تغيير جميع المفاتيح السرية المكشوفة
- [ ] تم إضافة r2_config.dart إلى .gitignore
- [ ] تم تطبيق Firebase Remote Config
- [ ] تم التحول إلى Firebase Authentication
- [ ] تم تثبيت flutter_secure_storage
- [ ] تم تحديث قواعد أمان Firebase
- [ ] تم اختبار تسجيل الدخول/التسجيل
- [ ] تم مراجعة جميع نقاط الوصول للبيانات

---

## 📞 إذا احتجت مساعدة

هذه إصلاحات حرجة، إذا واجهت أي مشكلة:
1. اطلب المساعدة فوراً
2. لا تنشر الكود قبل تطبيق هذه الإصلاحات
3. قم باختبار كل شيء على بيئة تطوير أولاً

**تاريخ الإنشاء:** 5 فبراير 2026  
**الأولوية:** 🔴 حرجة جداً
