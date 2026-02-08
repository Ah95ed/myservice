# دليل استخدام الخدمات الأمنية الجديدة
## Security Services Usage Guide

**الهدف:** شرح كيفية استخدام الخدمات الأمنية الجديدة في التطبيق

---

## 🔐 الخدمات الثلاث

### 1. SecureConfig - المفاتيح السرية
```dart
// الاستخدام:
import 'package:Al_Zab_township_guide/Services/secure_config.dart';

// يتم التهيئة تلقائياً في main.dart
// لا تحتاج لفعل شيء - تم التهيئة بالفعل!

// الوصول إلى المفاتيح:
String accessKeyId = SecureConfig.r2AccessKeyId;
String secretKey = SecureConfig.r2SecretAccessKey;
String endpoint = SecureConfig.r2Endpoint;
```

### 2. SecureStorageService - تخزين البيانات الآمنة
```dart
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';

// حفظ بيانات المستخدم
await SecureStorageService.saveUserData(
  name: 'أحمد محمد',
  email: 'ahmed@example.com',
  phone: '9647XXXXXXXX',
  uid: 'user123',
);

// استرجاع البيانات
Map<String, dynamic>? userData = 
    await SecureStorageService.getUserData();

// حفظ التوكن
await SecureStorageService.saveToken('token_xyz...');

// استرجاع التوكن
String? token = await SecureStorageService.getToken();

// تسجيل الخروج - مسح كل البيانات
await SecureStorageService.clearAll();
```

### 3. AuthService - المصادقة الآمنة
```dart
import 'package:Al_Zab_township_guide/Services/auth_service.dart';

// إنشاء instance
final authService = AuthService();

// تسجيل حساب جديد
try {
  UserCredential? credential = await authService.signUp(
    email: 'ahmed@example.com',
    password: 'SecurePass123!',
    name: 'أحمد محمد',
    phone: '9647XXXXXXXX',
  );
  print('✅ Account created');
} catch (e) {
  print('❌ Error: $e');
}

// تسجيل الدخول
try {
  UserCredential? credential = await authService.signIn(
    email: 'ahmed@example.com',
    password: 'SecurePass123!',
  );
  print('✅ Signed in');
} catch (e) {
  print('❌ Error: $e');
}

// تسجيل الخروج
await authService.signOut();
```

---

## 📝 مثال عملي: تحديث LoginProvider

### الكود الجديد:
```dart
import 'package:Al_Zab_township_guide/Services/auth_service.dart';
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';

class LoginProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // استخدام Firebase Auth الآمنة
      UserCredential? credential = await _authService.signIn(
        email: email,
        password: password,
      );

      if (credential != null && credential.user != null) {
        print('✅ تسجيل دخول ناجح');
        
        // الانتقال للشاشة الرئيسية
        Navigator.pushReplacementNamed(context, MainScreen.ROUTE);
      }
    } catch (e) {
      _error = e.toString();
      print('❌ خطأ: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### الفروقات:
```dart
// قديم (غير آمن):
Future<void> checkData(String phone, String pass) async {
  dataSnapshot = await databaseReference
      .child('auth')
      .child(phone)
      .get();
  // كلمات المرور مخزنة بنص صريح! ❌
}

// جديد (آمن):
Future<void> login(String email, String password) async {
  UserCredential? credential = await _authService.signIn(
    email: email,
    password: password,
  );
  // Firebase Auth تتعامل مع كلمات المرور بأمان ✅
}
```

---

## 🚀 تحديث SignupProvider

```dart
import 'package:Al_Zab_township_guide/Services/auth_service.dart';

class SignupProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<void> signup(
    BuildContext context,
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      UserCredential? credential = await _authService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (credential != null) {
        // إرسال OTP (اختياري)
        // sendOTP(email);
        
        Navigator.pushReplacementNamed(context, MainScreen.ROUTE);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
```

---

## 🔄 تحديث CloudflareR2Service

```dart
import 'package:Al_Zab_township_guide/Services/secure_config.dart';

class CloudflareR2Service {
  // بدلاً من:
  // const String R2_ACCESS_KEY_ID = 'a3c8a9e6a4bf...';
  
  // استخدم:
  static Future<Uri> presignedGetUrl(String key) async {
    final accessKeyId = SecureConfig.r2AccessKeyId;
    final secretAccessKey = SecureConfig.r2SecretAccessKey;
    final endpoint = SecureConfig.r2Endpoint;
    
    // استخدام المفاتيح الآمنة...
  }
}
```

---

## ✅ قائمة التحقق للتطبيق الآمن

### في كل Provider:
- [ ] لا تخزن كلمات المرور مطلقاً
- [ ] استخدم AuthService فقط
- [ ] احفظ البيانات الحساسة في SecureStorageService
- [ ] امسح البيانات عند تسجيل الخروج

### في كل Service:
- [ ] استخدم SecureConfig للمفاتيح
- [ ] استخدم SecureStorageService للبيانات الحساسة
- [ ] لا توجد مفاتيح في الكود

### في Firebase:
- [ ] Remote Config محدثة
- [ ] Authentication مفعلة
- [ ] Rules محدثة

---

## 🚨 أخطاء شائعة يجب تجنبها

### ❌ خطأ 1: نسيان التهيئة
```dart
// خطأ - لم نهيّ SecureConfig:
String key = SecureConfig.r2AccessKeyId;

// صحيح - تم التهيئة في main.dart بالفعل:
// لا تحتاج لفعل شيء، يتم استدعاء init() تلقائياً
```

### ❌ خطأ 2: استخدام SharedPreferences للبيانات الحساسة
```dart
// خطأ - غير آمن:
shared!.setString('password', '12345');

// صحيح:
await SecureStorageService.saveToken('eyJhbGc...');
```

### ❌ خطأ 3: نسيان async/await
```dart
// خطأ:
String email = SecureStorageService.getUserEmail();

// صحيح:
String? email = await SecureStorageService.getUserEmail();
```

### ❌ خطأ 4: تخزين مفاتيح في الكود
```dart
// خطأ - لا تفعل هذا أبداً:
const String API_KEY = 'a3c8a9e6a4bf...';

// صحيح - ضعها في Firebase Remote Config:
String key = SecureConfig.r2AccessKeyId;
```

---

## 📈 الفوائد

### الأمان
- ✅ كلمات المرور مشفرة بواسطة Firebase
- ✅ مفاتيح API آمنة في Remote Config
- ✅ بيانات محلية مشفرة بواسطة OS

### الأداء
- ✅ بدون طلبات قاعدة بيانات إضافية للمصادقة
- ✅ cache المفاتيح محلياً
- ✅ لا حاجة لتخزين كلمات المرور

### الصيانة
- ✅ مركزي - Firebase يدير المصادقة
- ✅ قابل للتوسع - إضافة ميزات جديدة سهل
- ✅ موثوق - Google-managed infrastructure

---

## 🔗 الملفات ذات الصلة

- `lib/Services/secure_config.dart` - المفاتيح الآمنة
- `lib/Services/secure_storage_service.dart` - التخزين الآمن
- `lib/Services/auth_service.dart` - المصادقة الآمنة
- `SECURITY_FIXES_GUIDE.md` - دليل الإصلاحات التفصيلي
- `SECURITY_IMPLEMENTATION_START.md` - خطوات البدء

---

## 🆘 استكشاف الأخطاء

### المشكلة: "SecureConfig not initialized"
**الحل:** تأكد من استدعاء `await SecureConfig.init()` في main.dart
```dart
// في main.dart
await SecureConfig.init();
```

### المشكلة: "User not found"
**الحل:** تأكد من استخدام البريد الإلكتروني الصحيح وكلمة المرور
```dart
// استخدم البريد الإلكتروني، ليس رقم الهاتف
authService.signIn(
  email: 'ahmad@example.com',  // ✅ صحيح
  password: 'SecurePass123!',
);
```

### المشكلة: "Token is null"
**الحل:** تأكد من استدعاء signIn بنجاح أولاً
```dart
// يجب أن يكون المستخدم مسجلاً دخول أولاً:
await authService.signIn(...);
String? token = await authService.getToken();
```

---

## 📚 مراجع إضافية

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Firebase Remote Config](https://firebase.google.com/docs/remote-config)

---

**تم الإنشاء:** 5 فبراير 2026  
**النسخة:** 1.0  
**آخر تحديث:** 5 فبراير 2026

---

💡 **ملاحظة:** اقرأ `SECURITY_FIXES_GUIDE.md` للحصول على تفاصيل كاملة عن كيفية إعداد Firebase Remote Config.
