import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginModel {
  String? name, email, phone, password;
  LoginModel({this.name, this.email, this.phone, this.password});

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

  Future<void> checkData(String phone, String pass) async {
    try {
      final response = await CloudflareApi.instance.login(
        phone: phone,
        password: pass,
      );
      final user = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;
      await SecureStorageService.saveToken(token);
      await SecureStorageService.saveUserData(
        name: user['name'] ?? '',
        email: user['email'] ?? '',
        phone: user['phone'] ?? '',
        uid: user['id'] ?? '',
      );
      await shared!.setString('nameUser', user['name'] ?? '');
      await shared!.setString('emailUser', user['email'] ?? '');
      await shared!.setString('phoneUser', user['phone'] ?? '');
      await shared!.setBool('isRegister', true);
      Navigator.of(MyApp.getContext()!).pop();
      MyApp.getContext()!.read<Providers>().managerScreenSplash(
        MainScreen.ROUTE,
        MyApp.getContext()!,
        false,
      );
    } catch (_) {
      Navigator.of(MyApp.getContext()!).pop();
      ScaffoldMessenger.of(
        MyApp.getContext()!,
      ).showSnackBar(SnackBar(content: Text(Translation['error_password'])));
      await shared!.setBool('isRegister', false);
    }
  }
}
