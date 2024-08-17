import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenNumber/OTPScreenNumber.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class UpdateModel {
  String? name, number;
  String? typeService, DocumentID;
  Client? client;
  DatabaseReference? _databaseRef;
  UpdateModel() {
    _databaseRef = FirebaseDatabase.instance.ref();
    client = Client();
    client!
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('66b5930400399d8fd3ee')
        .setSelfSigned(status: true);
  }
  Future<void> searchService(
    String? selectedValue,
    String n,
    BuildContext ctx,
  ) async {
    CollectionReference querySnapshot =
        await FirebaseFirestore.instance.collection(selectedValue!);
    querySnapshot.where('number', isEqualTo: n).get().then(
      (value) async {
        value.docs.map((v) {
          if (v.exists) {
            Navigator.of(ctx).pop();
            DocumentID = v.id;
            typeService = selectedValue;
            sendSMS(
              ctx,
              n,
            );
            return;
          } else {
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  Translation[Language.not_phond_found],
                ),
              ),
            );
            return;
          }
        }).toList();
        // return value;
      },
      onError: (e) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      },
    );
  }

  List<String> types = [
    Constant.A_Plus,
    Constant.A_Minus,
    Constant.B_Plus,
    Constant.B_Minus,
    Constant.O_Plus,
    Constant.O_Minus,
    Constant.AB_Plus,
    Constant.AB_Minus
  ];

  Future<void> searchTypes(BuildContext ctx, String n) async {
    for (var e in types) {
      CollectionReference querySnapshot =
          await FirebaseFirestore.instance.collection(e);
      querySnapshot.get().then(
        (r) {
          for (var element in r.docs) {
            if (n == element.get('number')) {
              typeService = e;
              DocumentID = element.id;
              sendSMS(ctx, n);
              break;
            }
          }
        },
      );
    }
  }

  Future<void> sendSMS(
    BuildContext c,
    String number,
  ) async {
    String num = number.substring(1);
    final account = Account(client!);
    final token = await account.createPhoneToken(
      userId: ID.unique(),
      phone: '+964$num',
    );
    await shared!.setString('userId', token.userId);
    await shared!.setString('numberDelete', number);
   c.read<Providers>().managerScreen(
          OTPScreenNumber.Route,
          c,
    
    );
   

  }

  deleteDataFromRealtimeAndFireStore(BuildContext c) async {
   await deletefromrealTime(c);
   await deleteFromFirStore(c);
  }

   deletefromrealTime(BuildContext c) async {
    await _databaseRef!
        .child('auth')
        .child(shared!.getString('numberDelete')!)
        .remove()
        .then(
          (t) {},
        );
  }

  deleteFromFirStore(BuildContext c) async {
    await FirebaseFirestore.instance
        .collection(typeService!)
        .doc(DocumentID)
        .delete()
        .then((v) {
      Navigator.of(c).pop();
      ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(
          content: Text(
            Translation[Language.done],
          ),
        ),
      );
    });
  }
}
