import 'dart:developer';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Models/SharedModel/SharedModel.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupModel {
  String? _name;
  String? _email;
  String? _password;
  String? _phone;
  String? _token;
  Providers? read;

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
    sharesModel = SharedModel();

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
  SharedModel? sharesModel;

  Future<bool> sendCodeEmail(BuildContext context, String email) async {
    if (await EmailOTP.sendOTP(email: email)) {
      Logger.logger("message otp ${EmailOTP.getOTP()}");
      Logger.logger('message sendCodeEmail -> ok');
      read!.managerScreen(OtpScreenEmail.Route, _ctx!);
      Navigator.pop(context);

      return true;
    } else {
      Logger.logger('message sendCodeEmail -> error');
      Logger.logger('message sendCodeEmail -> Field');
      Navigator.pop(context);

      ScaffoldMessenger.of(_ctx!).showSnackBar(
        SnackBar(content: Text(Translation[Language.error_email])),
      );
      return false;
    }
  }

  Future<void> saveData(BuildContext context, Map<String, String> data) async {
    _name = data['name'];
    _email = data['email'];
    _password = data['password'];
    _phone = data['phone'];
    await registerInRealTime(context);
  }

  Future<void> registerInRealTime(BuildContext ctx) async {
    try {
      // تحقق من البريد أو الهاتف لجعل المستخدم أدمن
      final isAdmin =
          (_email == 'amhmeed31@gmail.com' || _phone == '07824854526') ? 1 : 0;
      final response = await CloudflareApi.instance.register(
        name: _name ?? '',
        email: _email ?? '',
        phone: _phone ?? '',
        password: _password ?? '',
        isAdmin: isAdmin ,
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
      Navigator.pop(ctx);
      await shared!.setString('nameUser', user['name'] ?? '');
      await shared!.setString('emailUser', user['email'] ?? '');
      await shared!.setString('phoneUser', user['phone'] ?? '');
      await shared!.setBool('isRegister', true);
      await shared!.setBool('isAdmin', isAdmin == 1);
      sharesModel!.managerScreenSplash(MainScreen.ROUTE, ctx, false);
    } catch (error) {
      log('message registerInRealTime -> $error');
      ScaffoldMessenger.of(
        _ctx!,
      ).showSnackBar(SnackBar(content: Text('Error Register')));
      sharesModel!.managerScreenSplash(LoginScreen.Route, ctx, false);
    }
  }
}
