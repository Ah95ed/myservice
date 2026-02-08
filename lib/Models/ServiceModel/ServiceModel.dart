import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/material.dart';

class ServiceModel {
  late String phone;
  ServiceModel() {
    phone = shared!.getString('phoneUser') ?? '';
  }

  setDataInFirestore(
    BuildContext context,
    String collection,
    Map<String, dynamic> data,
  ) async {
    await CloudflareApi.instance.addCollectionItem(collection, data);

    await Future.delayed(Duration(seconds: 2), () async {
      Navigator.pop(context);
      await showSnakeBar(context, Translation[Language.done]);
    });
  }
}
