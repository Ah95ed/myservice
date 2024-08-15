import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateModel {
  Future<void> searchService(
    String? selectedValue,
    String number,
  ) async {
    CollectionReference querySnapshot =
        await FirebaseFirestore.instance.collection(selectedValue!);
    querySnapshot.where('number', isEqualTo: number).get().then(
      (value) async {
        value.docs.map((v) {
          if (v.exists) {
            return;
          }
          ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
            SnackBar(
              content: Text(
                Translation['not_phond_found'],
              ),
            ),
          );
          Logger.logger('message: value ${v.get('number')}');
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

  void searchTypes(String n) async {
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
              // context.read<OTPEmailProvider>().sendCode(n);
              break;
            }
            // context.read<OTPEmailProvider>().sendCode(n);
            break;
          }
        },
      );
    }
  }
}
