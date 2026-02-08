// ملف الثوابت المشتركة في التطبيق
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'دليل ناحية الزاب';
  static const String appVersion = '1.0.0';

  // روابط Cloudflare
  static const String cloudflareWorkerUrl =
      'https://blood.amhmeed31.workers.dev';
  static const String cloudflareDomain =
      'https://api.yourdomain.com'; // إذا كان لديك دومين مخصص

  // نقاط النهاية للـ APIs
  static const String bloodDonorsEndpoint = 'blood-donors';
  static const String doctorsEndpoint = 'doctors';
  static const String professionalsEndpoint = 'professionals';
  static const String authLoginEndpoint = 'auth/login';
  static const String authSignupEndpoint = 'auth/signup';
  static const String developerMessageEndpoint = 'developer/message';
  static const String appInfoEndpoint = 'app/info';
  static const String imagesUploadEndpoint = 'images/upload';
  static const String searchEndpoint = 'search';

  // مسارات الصور
  static const String logoPath = 'assets/logo/asd.png';
  static const String instagramPath = 'assets/logo/instagram.png';
  static const String whatsappPath = 'assets/logo/whatsapp.png';
  static const String messengerPath =
      'assets/logo/messenger.png'; // أحجام الشاشة الافتراضية
  static const double defaultScreenWidth = 375.0;
  static const double defaultScreenHeight = 812.0;

  // قيم الحشو والمسافات
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // أنصاف أقطار الحدود
  static const double smallRadius = 8.0;
  static const double mediumRadius = 16.0;
  static const double largeRadius = 24.0;

  // أحجام الخطوط
  static const double smallFontSize = 12.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 20.0;
  static const double xlargeFontSize = 24.0;

  // رسائل الخطأ
  static const String networkError = 'فشل في الاتصال بالإنترنت';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String emptyFieldError = 'هذا الحقل مطلوب';
  static const String invalidEmailError = 'البريد الإلكتروني غير صحيح';
  static const String invalidPhoneError = 'رقم الهاتف غير صحيح';

  // رسائل النجاح
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String signupSuccess = 'تم إنشاء الحساب بنجاح';
  static const String dataUpdatedSuccess = 'تم تحديث البيانات بنجاح';

  // مفاتيح SharedPreferences
  static const String splashKey = 'spalsh';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String userTokenKey = 'userToken';

  // أنواع الخدمات
  static const String bloodService = 'blood';
  static const String doctorService = 'doctor';
  static const String professionService = 'profession';

  // أنواع البحث
  static const String searchTypeAll = 'all';
  static const String searchTypeBlood = 'blood';
  static const String searchTypeDoctor = 'doctor';
  static const String searchTypeProfession = 'profession';
}

// ملف للتحقق من صحة البيانات
class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return AppConstants.emptyFieldError;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return AppConstants.invalidEmailError;
    }

    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return AppConstants.emptyFieldError;
    }

    // تحقق من أن الرقم يحتوي على أرقام فقط وطوله مناسب
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(phone)) {
      return AppConstants.invalidPhoneError;
    }

    return null;
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'يرجى إدخال $fieldName'
          : AppConstants.emptyFieldError;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }

    if (password.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    return null;
  }
}
