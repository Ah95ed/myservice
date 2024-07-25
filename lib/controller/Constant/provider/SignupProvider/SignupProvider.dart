import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool isSignup = false;
  late SignupModel model;
  Future<void> registerInRealTime(
    SignupModel m,
    BuildContext context,
  ) async {
    isSignup = true;
    model = await SignupModel(
      name: m.name,
      email: m.email,
      password: m.password,
      phone: m.phone,
    );
    await model.register(context);
    
    notifyListeners();
  }
  void startLoading() {
    isSignup = true;
    notifyListeners();
  }

  void stopLoading() {
    isSignup = false;
    notifyListeners();
  }
}
