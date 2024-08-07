// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPEmailProvider with ChangeNotifier {
  String _verificationId = '';
  Future<void> sendCode(String phone) async {
    String num = phone.substring(1);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+964$num',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification.
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Logger.logger('Verification failed: ${e.message}');
        // Logger.logger(shared!.getInt('num').toString());
        if (shared!.getInt('num') == 3) {
          MyApp.getContext()!
              .read<Providers>()
              .managerScreen(MessageDeveloper.Route, MyApp.getContext()!);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // setState(() {
        _verificationId = verificationId;
        shared!.setString('verificationId', _verificationId);
        Logger.logger('message verificationId -> $_verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // setState(() {
        _verificationId = verificationId;
        // });
      },
    );
  }
}
