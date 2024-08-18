import 'package:Al_Zab_township_guide/Models/DoctorModel/DoctorModel.dart';
import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorData {
  Future<List<DoctorModel>?> getData() async {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final collectionRef =
        firestoreInstance.collection(ServiceCollectios.Doctor.name);
    final querySnapshot =
        await collectionRef.where('bool', isEqualTo: true).get();
    return querySnapshot.docs.map((e) {
      return DoctorModel(
        name: e['name'],
        presence: e['presence'],
        specialization: e['specialization'],
        number: e['number'],
        title: e['title'],
      );
    }).toList();
  }
}


  // Future getData(String collection) async {
  //   s.clear();
  //   FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  //   final collectionRef = firestoreInstance.collection(collection);
  //   final querySnapshot = await collectionRef.where('bool', isEqualTo: true).get();
  //   s = querySnapshot.docs.map((e) => e).toList();
  //   notifyListeners();
  // }