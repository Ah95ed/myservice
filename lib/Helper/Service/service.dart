import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/firebase_options.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:appwrite/appwrite.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? shared;
// late String path;
Client? client;
Future<void> init() async {
  // path = await 'assets/logo/asd.png';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  client = await Client();
  await client!
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('66b5930400399d8fd3ee')
      .setSelfSigned(status: true);
  shared = await SharedPreferences.getInstance();
  await initLang(shared!.getString('lang') ?? "ar");
  EmailOTP.config(
    appName: S().title,
    otpType: OTPType.numeric,
    expiry: 60000,
    emailTheme: EmailTheme.v6,
    appEmail: 'amhmeed31@gmail.com',
    otpLength: 4,
  );
}
