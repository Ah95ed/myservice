import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editmodel {
  Future<List<DocumentSnapshot>> searchAcrossCollections(
      String collection, String searchTerm) async {
    List<DocumentSnapshot> results = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('number', isEqualTo: searchTerm)
        .get();
    Logger.logger('message editmodel ${querySnapshot.docs}');

    results.addAll(querySnapshot.docs);

    return results;
  }
}
