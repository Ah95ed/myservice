import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  // String? name;
  // String? email;
  // String? password;
  // String? phone;
  late SignupModel model;
  void registerInRealTime(SignupModel m) {

    model = SignupModel(
      name: m.name,
      email: m.email,
      password: m.password,
      phone: m.phone,
    );
    model.register();
    notifyListeners();
  }
}
