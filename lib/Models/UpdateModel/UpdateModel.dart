import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenNumber/OTPScreenNumber.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateModel {
  Client? client;
  UpdateModel() {
    client = Client();
    client!
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('66b5930400399d8fd3ee')
        .setSelfSigned(status: true);
  }
  Future<void> searchService(
    String? selectedValue,
    String number,
    BuildContext ctx,
  ) async {
    CollectionReference querySnapshot =
        await FirebaseFirestore.instance.collection(selectedValue!);
    querySnapshot.where('number', isEqualTo: number).get().then(
      (value) async {
        value.docs.map((v) {
          if (v.exists) {
            Navigator.of(ctx).pop();

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
        ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
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
    if (shared!.getInt('num') == null) {
      shared!.setInt('num', 1);
    } else {
      int? nshaerd = shared!.getInt('num');
      shared!.setInt('num', nshaerd! + 1);
    }

    for (var e in types) {
      CollectionReference querySnapshot =
          await FirebaseFirestore.instance.collection(e);
      querySnapshot.get().then(
        (r) {
          for (var element in r.docs) {
            if (n == element.get('number')) {
              Logger.logger('message ---===>>> ${element.get('number')!}');
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
    await account
        .createPhoneToken(
      userId: ID.unique(),
      phone: '+964$num',
    )
        .then((v) {
      Provider.of<Providers>(c).managerScreen(OTPScreenNumber.Route, c);
    });
// ! if u need token .. active this line ~_~

// final userId = token.userId;
  }
}
