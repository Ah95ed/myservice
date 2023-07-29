import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';


class Providers with ChangeNotifier {
  List s = [];

  List search = [];
  List save = [];
  Widget title = const Text('');
  Icon actionsicon = const Icon(Icons.search);
  final TextEditingController number = TextEditingController();

  void changewidget(String titles) {
    if (actionsicon.icon == Icons.search) {
      save = s;
      actionsicon = const Icon(Icons.close);
      title = TextField(
        controller: number,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
        onSubmitted: (v) {
          searchName(v);
        },
      );
      notifyListeners();
    } else {
      s = save;
      save = [];
      search = [];
      number.text = "";
      actionsicon = const Icon(Icons.search);
      title = Text(titles);
      notifyListeners();
    }
  }

  Future<void> searchName(String? name) async {
    if (name == null) return;

    for (  var element in  s) {
      if ( element['name'].toString().contains(name)) {
        search.add(element);
      }
    }
     s = search;
    notifyListeners();
  }

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
