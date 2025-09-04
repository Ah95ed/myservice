import 'package:Al_Zab_township_guide/Models/DeveloperModel/DeveloperModel.dart';
import 'package:flutter/material.dart';

class DeveloperController extends ChangeNotifier {
  void sendDataToDeveloper(Map<String, dynamic> data, String number) async {
    await DeveloperModel().registerInRealTime(data, number);
    notifyListeners();
  }
}
