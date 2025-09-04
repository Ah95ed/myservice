import 'package:Al_Zab_township_guide/Models/DoctorModel/DoctorData.dart';
import 'package:Al_Zab_township_guide/Models/DoctorModel/DoctorModel.dart';
import 'package:flutter/material.dart';

class DoctorProvider with ChangeNotifier {
  DoctorData? data;
  List<DoctorModel>? doctors = [];

  void getDataAll() async {
    data = DoctorData();
    doctors = await data!.getData();
    notifyListeners();
  }
}
