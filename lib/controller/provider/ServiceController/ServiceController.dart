import 'package:Al_Zab_township_guide/Models/ServiceModel/ServiceModel.dart';
import 'package:flutter/material.dart';

class ServiceController with ChangeNotifier {
  ServiceModel? serviceModel;

  setDataInFirestore(BuildContext context,String collection,Map<String,dynamic> data) async {
    serviceModel = ServiceModel();
   await serviceModel!.setDataInFirestore(context,collection,data);
    notifyListeners();
  }
}
