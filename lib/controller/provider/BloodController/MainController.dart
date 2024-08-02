import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  int index = 2;
  int expanded = 1;

  void changeSelect(int vlaue) {
    index = vlaue;
    onSelected();
  }

  void onSelected() {
    this.expanded = 2;
    notifyListeners();
  }

  final bodys = [
    DoctorScreen(),
    ProfessionsScreen(),
    BloodScreen(),
    TheCars(),
    SatotaScreen()
  ];
}
