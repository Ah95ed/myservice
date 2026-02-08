# دليل إعادة تنظيم الكود
## Code Organization & Clean Architecture Guide

---

## 🏗️ البنية المعمارية المقترحة

### البنية الحالية (مشكلة)

```
lib/
  controller/
    provider/          # مشكلة: مزيج من concerns
    SignupProvider/
    ForgetPassword/
  provider/           # مشكلة: تكرار
  Models/            # Models مختلطة
  Service/           # خدمات
  Helper/
    Service/         # تكرار مع Service/
```

### البنية المقترحة (Clean Architecture)

```
lib/
  core/
    constants/
      app_constants.dart
      api_constants.dart
      color_constants.dart
    theme/
      app_theme.dart
      colors.dart
    utils/
      validators.dart
      formatters.dart
    widgets/          # Widgets مشتركة
      custom_button.dart
      custom_text_field.dart
    services/         # خدمات مشتركة
      preferences_service.dart
      secure_storage_service.dart
      
  features/
    auth/
      data/
        models/
          user_model.dart
          login_model.dart
        repositories/
          auth_repository_impl.dart
        datasources/
          auth_remote_datasource.dart
      domain/
        entities/
          user.dart
        repositories/
          auth_repository.dart
        usecases/
          login_usecase.dart
          signup_usecase.dart
      presentation/
        providers/
          login_provider.dart
          signup_provider.dart
        pages/
          login_page.dart
          signup_page.dart
        widgets/
          login_form.dart
          
    blood/
      data/
        models/
          blood_donor_model.dart
        repositories/
          blood_repository_impl.dart
      domain/
        entities/
          blood_donor.dart
        repositories/
          blood_repository.dart
        usecases/
          get_donors_by_type_usecase.dart
      presentation/
        providers/
          blood_provider.dart
        pages/
          blood_screen.dart
          show_donors_screen.dart
        widgets/
          blood_type_button.dart
          
    doctors/
      # نفس البنية
      
    books/
      # نفس البنية
      
  main.dart
  app.dart
```

---

## 📝 قواعد التسمية (Naming Conventions)

### أسماء الملفات
```dart
// ✅ جيد
user_model.dart
login_provider.dart
blood_repository.dart

// ❌ سيء
UserModel.dart
Loginprovider.dart
bloodRepository.dart
```

### أسماء Classes
```dart
// ✅ جيد
class UserModel { }
class LoginProvider { }
class BloodRepository { }

// ❌ سيء
class user_model { }
class loginProvider { }
class Bloodrepository { }
```

### أسماء المتغيرات
```dart
// ✅ جيد
String userName;
List<Doctor> doctorsList;
bool isLoading;
int totalCount;

// ❌ سيء
String name; // غير واضح
List s = []; // عام جداً
String re = '0'; // ما معناه؟
```

### أسماء الثوابت
```dart
// ✅ جيد
static const String apiKey = 'xxx';
static const int maxRetries = 3;
static const Duration timeout = Duration(seconds: 30);

// ❌ سيء
static const appEmail = 'xxx'; // يفتقد للنوع
```

---

## 🔧 ملف الثوابت المنظم

```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  // منع إنشاء instance
  AppConstants._();
  
  // معلومات التطبيق
  static const String appName = 'AL-Zab Township Guide';
  static const String appEmail = 'amhmeed31@gmail.com';
  static const String privacyPolicyUrl = 'https://Ah95ed.github.io/privatePolice/';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.Blood.types';
  
  // فصائل الدم
  static const String bloodTypeAPlus = 'A+';
  static const String bloodTypeAMinus = 'A-';
  static const String bloodTypeBPlus = 'B+';
  static const String bloodTypeBMinus = 'B-';
  static const String bloodTypeOPlus = 'O+';
  static const String bloodTypeOMinus = 'O-';
  static const String bloodTypeABPlus = 'AB+';
  static const String bloodTypeABMinus = 'AB-';
  
  static const List<String> allBloodTypes = [
    bloodTypeAPlus,
    bloodTypeAMinus,
    bloodTypeBPlus,
    bloodTypeBMinus,
    bloodTypeOPlus,
    bloodTypeOMinus,
    bloodTypeABPlus,
    bloodTypeABMinus,
  ];
  
  // روابط خارجية
  static const String bloodInfoUrl = 'https://www.blood.co.uk/who-can-give-blood/';
}

// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();
  
  static const String firebaseRealtimeDbUrl = 
      'https://blood-types-77ce2-default-rtdb.firebaseio.com/';
  
  // مسارات Firebase Collections
  static const String usersCollection = 'users';
  static const String authCollection = 'auth';
  static const String bloodDonorsCollection = 'blood_donors';
  static const String doctorsCollection = 'doctors';
  static const String professionalsCollection = 'professionals';
  static const String carsCollection = 'cars';
  static const String satotaCollection = 'satota';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

// lib/core/constants/ui_constants.dart
class UIConstants {
  UIConstants._();
  
  // أحجام
  static const double buttonHeight = 50.0;
  static const double borderRadius = 15.0;
  static const double iconSize = 24.0;
  
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
```

---

## 🎯 استخدام Extension Methods

```dart
// lib/core/extensions/string_extensions.dart
extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  bool get isValidPhone {
    return RegExp(r'^\+?[0-9]{10,13}$').hasMatch(this);
  }
  
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// lib/core/extensions/context_extensions.dart
extension ContextExtensions on BuildContext {
  // Navigation
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
  
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // MediaQuery
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  // Scaffold
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// الاستخدام:
if (email.isValidEmail) { ... }
context.showSnackBar('تم الحفظ بنجاح');
final width = context.screenWidth;
```

---

## 🔨 إزالة التكرار (DRY Principle)

### مثال: Dialogs

```dart
// lib/core/utils/dialog_utils.dart
class DialogUtils {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
  
  static void showErrorDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

// الاستخدام:
await DialogUtils.showLoadingDialog(context);
// ... عملية
DialogUtils.hideLoadingDialog(context);
```

### مثال: Error Handling

```dart
// lib/core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'خطأ في الخادم']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'لا يوجد اتصال بالإنترنت']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

// lib/core/utils/error_handler.dart
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Failure) {
      return error.message;
    } else if (error is FirebaseException) {
      return _handleFirebaseError(error);
    } else if (error is SocketException) {
      return 'لا يوجد اتصال بالإنترنت';
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }
  
  static String _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'ليس لديك صلاحية للوصول';
      case 'unavailable':
        return 'الخدمة غير متاحة حالياً';
      default:
        return e.message ?? 'خطأ في Firebase';
    }
  }
}
```

---

## 📚 Documentation

### إضافة تعليقات للكود

```dart
/// نموذج يمثل بيانات المستخدم
/// 
/// يحتوي على المعلومات الأساسية للمستخدم بما في ذلك
/// الاسم، البريد الإلكتروني، ورقم الهاتف.
class UserModel {
  /// الاسم الكامل للمستخدم
  final String name;
  
  /// البريد الإلكتروني (يجب أن يكون صالحاً)
  final String email;
  
  /// رقم الهاتف بصيغة دولية
  final String phone;
  
  /// إنشاء نموذج مستخدم جديد
  /// 
  /// يتطلب [name], [email], و [phone].
  /// 
  /// مثال:
  /// ```dart
  /// final user = UserModel(
  ///   name: 'أحمد محمد',
  ///   email: 'ahmed@example.com',
  ///   phone: '+9647xxxxxxxx',
  /// );
  /// ```
  const UserModel({
    required this.name,
    required this.email,
    required this.phone,
  });
}
```

---

## ✅ قائمة التحقق

### التنظيم العام
- [ ] إعادة هيكلة المجلدات حسب Clean Architecture
- [ ] فصل Business Logic عن UI
- [ ] توحيد أسماء الملفات والمجلدات

### الكود
- [ ] استخدام naming conventions صحيحة
- [ ] إنشاء ملفات constants منظمة
- [ ] إضافة extension methods
- [ ] إزالة الكود المكرر
- [ ] إضافة error handling موحد

### Documentation
- [ ] إضافة comments للـ complex logic
- [ ] إنشاء README لكل feature
- [ ] توثيق الـ public APIs

---

**تم الإنشاء:** 5 فبراير 2026  
**الأولوية:** متوسطة 🟡
