import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginModel {
  String? name, email, phone, password;
  late DatabaseReference databaseReference;

  LoginModel({this.name, this.email, this.phone, this.password}) {
    databaseReference = FirebaseDatabase.instance
        .refFromURL('https://blood-types-77ce2-default-rtdb.firebaseio.com/');
  }

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }

  late DataSnapshot dataSnapshot;

  Future<void> checkData(
    String phone,
    String pass,
  ) async {
    dataSnapshot = await databaseReference.child('auth').child(phone).get();
    if (await dataSnapshot.exists) {
      await loginFirebase(
        phone,
        pass,
      );
    } else {
      Navigator.of(MyApp.getContext()!).pop();
      ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text(Translation['is_not_exist'])),
     
      );
      await shared!.setBool('isRegister', false);
      return;
    }
  }

  Future<void> loginFirebase(
    String phone,
    String password,
  ) async {
    databaseReference.child('auth').child(phone).once().then(
      (v) async {
        final data = v.snapshot.value as Map;
        if (data['password'] == password) {
          // isLogin = true;
          await shared!.setString('nameUser', data['name']);
          await shared!.setString('emailUser', data['email']);
          await shared!.setString('phoneUser', data['phone']);
          await shared!.setBool('isRegister', true);
          Navigator.of(MyApp.getContext()!).pop();
          MyApp.getContext()!.read<Providers>().managerScreenSplash(
                MainScreen.ROUTE,
                MyApp.getContext()!,
                false,
              );
          return;
        }
        Navigator.of(MyApp.getContext()!).pop();
        ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text(Translation['error_password'])),
     
      );
        return;
        // return isLogin;
      },
    );
    // return isLogin;
  }
}
