import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/Services/email_otp_service.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool isSignup = false;
  late SignupModel model;
  Map<String, String>? register;

  SignupProvider() {
    model = SignupModel();
    // تهيئة مكتبة إرسال البريد
    // EmailOtpService.instance.init();
  }
  void startLoading() {
    isSignup = true;
    notifyListeners();
  }

  void stopLoading() {
    isSignup = false;
    notifyListeners();
  }

  Future<void> saveData(BuildContext context, {required String otp}) async {
    if (register == null) return;
    await model.saveData(context, data: register!, otp: otp);
  }

  Future<void> sendCode(SignupModel m, BuildContext context) async {
    await EmailOtpService.instance.init();
    model = SignupModel(
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

    try {
      // Step 1: Send OTP Via the EmailOTP package to the user's email
      bool otpSent = await EmailOTP.sendOTP(email: m.email!);

      if (otpSent) {
        // Step 2: Request the token from Cloudflare API if needed, then move to OTP Screen
        // Note: You can now bypass the Cloudflare OTP request if you intend to only verify via EmailOTP.
        // For now, we keep the server registration logic if it expects an OTP generation locally.
        await CloudflareApi.instance.requestSignupOtp(
          email: m.email!,
          phone: m.phone!,
        );
        await model.sendCodeToScreen(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في إرسال رمز التحقق (OTP)')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    notifyListeners();
  }
}
