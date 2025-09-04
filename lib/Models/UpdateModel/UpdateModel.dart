import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenNumber/OTPScreenNumber.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateModel {
  String? name, number;
  String? typeService;
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
    CollectionReference querySnapshot = await FirebaseFirestore.instance
        .collection(selectedValue!);
    querySnapshot
        .where('number', isEqualTo: n)
        .get()
        .then(
          (value) async {
            value.docs.map((v) async {
              if (v.exists) {
                Navigator.of(ctx).pop();

                shared!.setString('collection', selectedValue);
                await shared!.setString('DocumentID', v.id);
                sendSMS(ctx, n);
                return;
              } else {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(Translation[Language.not_phond_found]),
                  ),
                );
                return;
              }
            }).toList();
            // return value;
          },
          onError: (e) {
            ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
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
    Constant.AB_Minus,
  ];

  Future<void> searchTypes(BuildContext ctx, String n) async {
    for (var e in types) {
      CollectionReference querySnapshot = await FirebaseFirestore.instance
          .collection(e);
      querySnapshot.get().then((r) async {
        for (var element in r.docs) {
          if (n == element.get('number')) {
            await shared!.setString('collection', e);
            await shared!.setString('DocumentID', element.id);

            await sendSMS(ctx, n);

            break;
          }
        }
      });
    }
  }

  Future<void> sendSMS(BuildContext c, String number) async {
    String num = number.substring(1);
    final account = Account(client!);
    final token = await account.createPhoneToken(
      userId: ID.unique(),
      phone: '+964$num',
    );
    Navigator.pop(c);
    await shared!.setString('userId', token.userId);
    await shared!.setString('numberDelete', number);
    Provider.of<Providers>(
      c,
      listen: false,
    ).managerScreen(OTPScreenNumber.Route, c);
  }

  String? Collection, DocumentID;
  Future<void> deleteDataFromRealtimeAndFireStore(BuildContext c) async {
    Collection = await shared!.getString('collection');
    DocumentID = await shared!.getString('DocumentID');
    await deleteFromFirStore(c);
    await deletefromrealTime(c);
    ScaffoldMessenger.of(c).showSnackBar(
      SnackBar(
        content: Text(Translation[Language.done]),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deletefromrealTime(BuildContext c, {String? number}) async {
    await _databaseRef!
        .child('auth')
        .child(number ?? await shared!.getString('numberDelete')!)
        .remove()
        .then((t) {
          Navigator.of(c).pop();
          shared!.remove('nameUser');
          shared!.remove('emailUser');
          shared!.remove('phoneUser');
          shared!.remove('isRegister');
          Scaffold.of(c).closeDrawer();
          ScaffoldMessenger.of(
            c,
          ).showSnackBar(SnackBar(content: Text(Translation[Language.done])));
        });
  }

  Future<void> deleteFromFirStore(BuildContext c) async {
    await FirebaseFirestore.instance
        .collection(Collection!)
        .doc(DocumentID)
        .delete()
        .then((v) {
          Navigator.of(c).pop();
          ScaffoldMessenger.of(
            c,
          ).showSnackBar(SnackBar(content: Text(Translation[Language.done])));
        });
  }
}
