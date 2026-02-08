import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool isSignup = false;
  late SignupModel model;
  Map<String, String>? register;

  SignupProvider() {
    model = SignupModel();
  }
  void startLoading() {
    isSignup = true;
    notifyListeners();
  }

  void stopLoading() {
    isSignup = false;
    notifyListeners();
  }

  Future<void> saveData(BuildContext context) async {
    if (register == null) return;
    await model.saveData(context, register!);
  }

  Future<void> sendCode(SignupModel m, BuildContext context) async {
    model = await SignupModel(
      name: m.name,
      email: m.email,
      password: m.password,
      phone: m.phone,
      context: context,
    );
    this.register = {
      'name': m.name!,
      'email': m.email!,
      'phone': m.phone!,
      'password': m.password!,
    };
    Logger.logger("message init");

    EmailOTP.setSMTP(
      host: 'smtp.gmail.com',
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      username: 'amhmeed31@gmail.com',

      /// your google account mail
      password: 'arhs xupn ktkc ypir',

      /// this password will get while creating app password
    );

    EmailOTP.config(
      appName: Translation[Language.title],
      otpType: OTPType.numeric,
      expiry: 40000,
      emailTheme: EmailTheme.v6,
      appEmail: 'amhmeed31@gmail.com',
      otpLength: 6,
    );
    await model.sendCodeEmail(context, m.email!);

    notifyListeners();
  }
}
