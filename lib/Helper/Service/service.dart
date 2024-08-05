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
 T? getShared<T>(String name) {
    switch (T) {
      case bool:
        return shared!.getBool(name) as T?;

      case String:
        return shared!.getString(name) as T?;

      case int:
        return shared!.getInt(name) as T?;

      case double:
        return shared!.getDouble(name) as T?;

      default:
        return null;
    }
  }

  void setShared<T>(String name, T value) {
    switch (T) {
      case bool:
        shared!.setBool(name, value as bool) as T?;
        break;
      case String:
        shared!.setString(name, value as String) as T?;
        break;
      case int:
        shared!.setInt(name, value as int) as T?;
        break;
      case double:
        shared!.setDouble(name, value as double) as T?;
        break;
      default:
        throw ArgumentError();
    }
  }
