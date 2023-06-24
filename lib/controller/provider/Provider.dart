import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tester_app/Models/SatotaModel.dart';

class Providers with ChangeNotifier {
  List sss = [];
  List s = [];

  Future getData(String collection) async {
    s.clear();
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final collectionRef = firestoreInstance.collection(collection);
    final querySnapshot = await collectionRef.get();
    for (var document in querySnapshot.docs) {
      s.add(document.data());
    }

    notifyListeners();
  }

  Future getDataSatota(String collection) async {
    sss.clear();
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final collectionRef = firestoreInstance.collection(collection);
    final querySnapshot = await collectionRef.get();
    for (var document in querySnapshot.docs) {
      sss.add(document.data());
    }
    notifyListeners();
  }

  void managerScreen(String route, BuildContext context, {Object? object}) {
    Navigator.pushNamed(context, route, arguments: object);
    notifyListeners();
  }
}
