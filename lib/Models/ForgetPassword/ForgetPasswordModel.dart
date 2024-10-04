import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class ForgetPasswordModel {
  Future<void> sendCodeEmail(
    BuildContext context,
    String _email,
  ) async {
    if (_email.isEmpty || !_email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translation[Language.error_email],
          ),
        ),
      );
      Navigator.pop(context);
      return;
    }
    if (await EmailOTP.sendOTP(email: _email)) {
      // Navigator.pop(context);
      Navigator.popAndPushNamed(
        context,
        OtpScreenEmail.Route,
        arguments: true,
        
      );
    } else {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Translation[Language.not_sent_email],
          ),
        ),
      );
      Navigator.pop(context);
      
      return;
    }
  }
}
