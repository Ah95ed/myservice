import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Models/DoctorModel/DoctorModel.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';

class DoctorData {
  Future<List<DoctorModel>?> getData() async {
    final data = await CloudflareApi.instance.getCollection(
      ServiceCollectios.Doctor.name,
    );
    return data.map((e) {
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
//   final collectionRef = firestoreInstance.collection(collection);
//   final querySnapshot = await collectionRef.where('bool', isEqualTo: true).get();
//   s = querySnapshot.docs.map((e) => e).toList();
//   notifyListeners();
// }
