import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeveloperModel {
  Future<void> registerInRealTime(Map<String, dynamic> data,String number) async {
    final DatabaseReference database = FirebaseDatabase.instance.refFromURL(
      'https://blood-types-77ce2-default-rtdb.firebaseio.com/',
    );
    await database.child('Edit').child(number).set(data).then(
      (value) {
        Logger.logger(' message -> then ok set in realtime ');
        ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text(S.current.done_to_send),
          duration: Duration(seconds: 2),
        ),
      );
      },
    ).onError((bool, error) {
      Logger.logger('message registerInRealTime -> $error');
      ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text('Error Register'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
