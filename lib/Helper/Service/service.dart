import 'package:Al_Zab_township_guide/firebase_options.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? shared;
Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  shared = await SharedPreferences.getInstance();
  EmailOTP.config(
    appName: S().title,
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'amhmeed31@gmail.com',
    otpLength: 4,
  );
}
