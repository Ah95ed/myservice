// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupModel {
  String? _name;
  String? _email;
  String? _password;
  String? _phone;
  String? _token;

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

  Future<void> register() async {
    try {
      final checkemail = await _auth.fetchSignInMethodsForEmail(email!);
      if (checkemail.isEmpty) {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        User? user = FirebaseAuth.instance.currentUser;
        token = await user!.getIdToken();
        registerInRealTime();
      } else {
        log('message email is Exist ');
      }
    } catch (e) {
      log('message register -> $e');
    }
  }

  void registerInRealTime() {
    final DatabaseReference database = FirebaseDatabase.instance
        .refFromURL('https://blood-types-77ce2-default-rtdb.firebaseio.com/');
    database.child('auth').child(phone!).set({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'token': token,
    }).then((value) {
      log('message registerInRealTime ->  ');

    }).onError((bool, error) {
      log('message registerInRealTime -> $error');
    });
  }
}
