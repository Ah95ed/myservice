import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:email_otp/email_otp.dart';

class EmailOtpService {
  // إنشاء Private constructor لضمان عدم إنشاء أكثر من كائن (Singleton)
  EmailOtpService._();

  // إنشاء الكائن الوحيد (Instance)
  static final EmailOtpService _instance = EmailOtpService._();

  // Factory constructor لإرجاع نفس الكائن دائمًا
  factory EmailOtpService() {
    return _instance;
  }

  static EmailOtpService get instance => _instance;

  bool _isInitialized = false;

  // دالة التهيئة (تهيئة البيانات مرة واحدة فقط)
  Future<void> init() async {
    if (_isInitialized) return;

    await EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'at.dev.iq@gmail.com',

      /// your google account mail
      password: 'vmcb kstf ljrq sues',

      /// this password will get while creating app password
    );

    await EmailOTP.config(
      appName: Translation[Language.title],
      otpType: OTPType.numeric,
      expiry: 100000,
      emailTheme: EmailTheme.v6,
      appEmail: 'at.dev.iq@gmail.com',
      otpLength: 6,
    );

    _isInitialized = true;
  }
}
