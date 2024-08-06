import 'dart:developer';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Models/SharedModel/SharedModel.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupModel {
  String? _name;
  String? _email;
  String? _password;
  String? _phone;
  String? _token;

  bool isSignup = false;

  SignupModel({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? token,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _phone = phone;
    _token = token;
    sharesModel = SharedModel();
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
  late BuildContext _ctx;

  Future<void> register(
    BuildContext context,
  ) async {
    this._ctx = context;
    try {
      final checkemail = await _auth.fetchSignInMethodsForEmail(email!);
      if (checkemail.isEmpty) {
        isSignup = true;
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        User? user = await FirebaseAuth.instance.currentUser;
        token = await user!.getIdToken();
        await registerInRealTime();
      } else {
        isSignup = false;
        log('message email is Exist ');
        await ScaffoldMessenger.of(_ctx).showSnackBar(
          SnackBar(
            content: Text('email is Exist '),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      await ScaffoldMessenger.of(_ctx).showSnackBar(
        SnackBar(
          content: Text('email is Exist $e'),
          duration: Duration(seconds: 3),
        ),
      );
      log('message register -> $e');
    }
  }

  Future<void> registerInRealTime() async {
    final DatabaseReference database = FirebaseDatabase.instance.refFromURL(
      'https://blood-types-77ce2-default-rtdb.firebaseio.com/',
    );
    await database.child('auth').child(phone!).set({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'token': token,
    }).then((value) {
      sharesModel!.managerScreenSplash(
        MainScreen.ROUTE,
        _ctx,
        false,
      );
      // log('message registerInRealTime ->  ');
    }).onError((bool, error) {
      isSignup = false;
      log('message registerInRealTime -> $error');
      ScaffoldMessenger.of(_ctx).showSnackBar(
        SnackBar(
          content: Text('Error Register'),
        ),
      );
    });
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
        shared!.setString( 'verificationId', _verificationId);
        log('message verificationId -> $_verificationId');
        sharesModel!.managerScreenSplash(OtpScreen.Route, _ctx, false);
      
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // setState(() {
        _verificationId = verificationId;
        // });
      },
    );
  }
}
