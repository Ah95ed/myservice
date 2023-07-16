import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Providers with ChangeNotifier {
  List s = [];

  Future getData(String collection) async {
    s.clear();
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final collectionRef = firestoreInstance.collection(collection);
    final querySnapshot = await collectionRef.get();
    s = querySnapshot.docs.map((e) => e).toList();
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
    }
    notifyListeners();
  }
}
