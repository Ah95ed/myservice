import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Models/LoginModel/LoginModel.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool isLoading = false;
  String? error;
  String? phone;
  String? password;
  late LoginModel model;

  LoginProvider() {
    model = LoginModel();
  }
  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  Future<void> login(
    BuildContext context,
    String? phone,
    String? password,
  ) async {
    await model.checkData(
      phone!,
      password!,
    );
    isLoading = await model.isLogin;
    Logger.logger('message Provider Loggin -> $isLoading');
    notifyListeners();
  }
//   void startLoading() {
//     isLoading = true;
//     notifyListeners();
//   }

//   void stopLoading() {
//     isLoading = false;
//     notifyListeners();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
}
