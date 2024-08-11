import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginModel {
  String? name, email, phone, password;
  late DatabaseReference databaseReference;

  LoginModel({this.name, this.email, this.phone, this.password}) {
    databaseReference = FirebaseDatabase.instance
        .refFromURL('https://blood-types-77ce2-default-rtdb.firebaseio.com/');
  }

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }

  late DataSnapshot dataSnapshot;

  Future<void> checkData(
    String phone,
    String pass,
  ) async {
    dataSnapshot = await databaseReference.child('auth').child(phone).get();
    if (await dataSnapshot.exists) {
      await loginFirebase(
        phone,
        pass,
      );
    } else {
      isLogin = false;
      return;
    }
  }

  bool isLogin = false;

  Future<bool> loginFirebase(
    String phone,
    String password,
  ) async {
    databaseReference.child('auth').child(phone).once().then(
      (v) {
        final data = v.snapshot.value as Map;
        if (data['password'] == password) {
          // isLogin = true;
          shared!.setString('nameUser', data['name']);
          shared!.setString('emailUser', data['email']);
          shared!.setString('phoneUser', data['phone']);
          shared!.setBool('isRegister', true);
          return isLogin= true;
        }
        return isLogin;
      },
    );
    return isLogin;
  }
}
