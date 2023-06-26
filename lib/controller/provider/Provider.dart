import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Providers with ChangeNotifier {
  List sss = [];
  List s = [];
  //  double? width;
  //  double? height;

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

  Future<void> callNumber(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('not call ____');
    }
    notifyListeners();
  }

  // void changeSizeScreen(double width,double height) {
  //   this.width =width;
  //   this.height = height;
  //   notifyListeners();
  // }
}
