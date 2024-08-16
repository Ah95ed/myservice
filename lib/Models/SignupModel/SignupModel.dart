import 'dart:developer';

import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Models/SharedModel/SharedModel.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupModel {
  String? _name;
  String? _email;
  String? _password;
  String? _phone;
  String? _token;
  Providers? read;

  DatabaseReference? database;
  BuildContext? _ctx;
  SignupModel({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? token,
    BuildContext? context,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _phone = phone;
    _token = token;
    this._ctx = context;
    database = FirebaseDatabase.instance.refFromURL(
      'https://blood-types-77ce2-default-rtdb.firebaseio.com/',
    );
    sharesModel = SharedModel();
    EmailOTP.config(
      appName: Translation[Language.title],
      otpType: OTPType.numeric,
      expiry: 60000,
      emailTheme: EmailTheme.v6,
      appEmail: 'amhmeed31@gmail.com',
      otpLength: 4,
    );
    read = MyApp.getContext()!.read<Providers>();
  }
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;
  String? get phone => _phone;
  String? get token => _token;

  // Setters
  set name(String? value) => _name = value;
  set email(String? value) => _email = value;
  set password(String? value) => _password = value;
  set phone(String? value) => _phone = value;
  set token(String? value) => _token = value;
  FirebaseAuth _auth = FirebaseAuth.instance;
  SharedModel? sharesModel;

  Future<void> sendCodeEmail() async {
    if (await EmailOTP.sendOTP(
      email: email!,
    )) {
      read!.managerScreen(OtpScreenEmail.Route, _ctx!);
      return;
    } else {
      ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(
          content: Text(
            Translation[Language.error_email],
          ),
        ),
      );
    }
  }

  String _verificationId = '';
  Future<void> sendCode() async {
    String num = phone!.substring(1);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+964$num',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification.
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        log('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // setState(() {
        _verificationId = verificationId;
        shared!.setString('verificationId', _verificationId);
        log('message verificationId -> $_verificationId');
        sharesModel!.managerScreenSplash(OtpScreenEmail.Route, _ctx!, false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // setState(() {
        _verificationId = verificationId;
        // });
      },
    );
  }

  Future<void> register(
    BuildContext context,
  ) async {
    try {
      final checkemail = await _auth.fetchSignInMethodsForEmail(email!);
      if (checkemail.isEmpty) {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        User? user = await FirebaseAuth.instance.currentUser;
        _token = await user!.getIdToken();
        await registerInRealTime(context);
      } else {
        log('message email is Exist ');
        await ScaffoldMessenger.of(_ctx!).showSnackBar(
          SnackBar(
            content: Text('email is Exist '),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      await ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(
          content: Text('email is Exist $e'),
          duration: Duration(seconds: 3),
        ),
      );
      log('message register -> $e');
    }
  }

  Future<void> saveData(
    BuildContext context,
    Map<String, String> data,
  ) async {
    _name = data['name'];
    _email = data['email'];
    _password = data['password'];
    _phone = data['phone'];
    await registerInRealTime(context);
  }

  Future<void> registerInRealTime(BuildContext ctx) async {
    DataSnapshot dataSnapshot =
        await database!.child('auth').child(_phone!).get();
    if (dataSnapshot.exists) {
      ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(
          content: Text(
            Translation[Language.is_number_exist],
          ),
        ),
      );
      sharesModel!.managerScreenSplash(LoginScreen.Route, ctx, false);
      return;
    }
    await database!.child('auth').child(_phone!).set({
      'name': _name,
      'email': _email,
      'phone': _phone,
      'password': _password,
      // 'token': _token,
    }).then((value) {
      shared!.setString('nameUser', _name!);
      shared!.setString('emailUser', _email!);
      shared!.setString('phoneUser', _phone!);
      shared!.setBool('isRegister', true);
      sharesModel!.managerScreenSplash(
        MainScreen.ROUTE,
        ctx,
        false,
      );
      // log('message registerInRealTime ->  ');
    }).onError((bool, error) {
      log('message registerInRealTime -> $error');
      ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(
          content: Text('Error Register'),
        ),
      );
    });
  }
}
