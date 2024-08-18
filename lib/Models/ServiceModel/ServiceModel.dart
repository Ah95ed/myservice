import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceModel {
  late FirebaseFirestore firestoreInstance;
 late String phone;
  ServiceModel() {
    firestoreInstance = FirebaseFirestore.instance;
    phone = shared!.getString('phoneUser')!;
  }

  setDataInFirestore(BuildContext context, String collection,
      Map<String, dynamic> data) async {
    await firestoreInstance
    .collection(collection)
    .doc(phone)
    .set(data);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      showSnakeBar(
        context,
        Translation[Language.done],
      );
    });
  }
}
