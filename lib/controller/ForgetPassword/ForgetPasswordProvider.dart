import 'package:Al_Zab_township_guide/Models/ForgetPassword/ForgetPasswordModel.dart';
import 'package:flutter/material.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  late ForgetPasswordModel _forgetPassword;
  bool isLoading = false;
  ForgetPasswordProvider() {
    _forgetPassword = ForgetPasswordModel();
  }
  void start() {
    isLoading = true;
    notifyListeners();
  }

  void stop() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendCode(String email, BuildContext context) async {
    await _forgetPassword.sendCodeEmail(context, email);
    notifyListeners();
  }
}
