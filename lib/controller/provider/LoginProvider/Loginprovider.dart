import 'dart:developer';
import 'package:Al_Zab_township_guide/Models/SharedModel/SharedModel.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  String? _name, _email, _password, _phone;
  SharedModel? sharedModel;

  Future<void> loginFirebase(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      saveData(context, email);
      // managerScreenSplash(MainScreen.ROUTE, context, false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided.');
      }
    }
  }

  Future<void> saveData(
    BuildContext context,
    String email, {
    String? password,
    String? name,
    String? phone,
  }) async {
    bool t = await sharedPreferences!.setBool('isRegister', true);

    if (t) {
      // _name = name;
      // _email = email;
      // _password = password;
      // _phone = phone;
      // await registerFirebase(email);
      // managerScreenSplash(MainScreen.ROUTE, context, false);
    }
    notifyListeners();
    // return t;
  }

  Future<void> registerFirebase(String email) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _email!,
      password: _password!,
    )
        .then((value) async {
      if (value.user!.email!.isEmpty) {
        UserCredential u =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        User? user = u.user;
        await registerInRealTime();
      }
    });
  }

  Future<void> registerInRealTime() async {
    final database = FirebaseDatabase.instance;
    database
        .ref('iphone')
        .child(_phone!)
        .set(
          {
            'name': _name,
            'phone': _phone,
            'email': _email,
            'password': _password,
          },
        )
        .then(
          (value) => {
            log('message RegisterInRealTime'),
          },
        )
        .onError(
          (error, stackTrace) => {},
        );
    notifyListeners();
  }
}
