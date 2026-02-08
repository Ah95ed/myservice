import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/Services/secure_storage_service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenNumber/OTPScreenNumber.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateModel {
  String? name, number;
  String? typeService;
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
    String n,
    BuildContext ctx,
  ) async {
    try {
      final found = await CloudflareApi.instance.lookupByNumber(
        selectedValue ?? '',
        n,
      );
      if (found == null) {
        Navigator.of(ctx).pop();
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(Translation[Language.not_phond_found])),
        );
        return;
      }
      Navigator.of(ctx).pop();
      shared!.setString('collection', found['type']);
      await shared!.setString('DocumentID', found['id']);
      sendSMS(ctx, n);
    } catch (e) {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
    try {
      final response = await CloudflareApi.instance.getDonorsByNumber(n);
      if (response.isEmpty) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(Translation[Language.not_phond_found])),
        );
        return;
      }
      final item = response.first;
      await shared!.setString('collection', 'donor');
      await shared!.setString('DocumentID', item['id']);
      await sendSMS(ctx, n);
    } catch (e) {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
    try {
      await CloudflareApi.instance.deleteUserByPhone(
        number ?? await shared!.getString('numberDelete')!,
      );
      await SecureStorageService.clearAll();
      Navigator.of(c).pop();
      shared!.remove('nameUser');
      shared!.remove('emailUser');
      shared!.remove('phoneUser');
      shared!.remove('isRegister');
      Scaffold.maybeOf(c)?.closeDrawer();
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(SnackBar(content: Text(Translation[Language.done])));
    } catch (e) {
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> deleteFromFirStore(BuildContext c) async {
    try {
      await CloudflareApi.instance.deleteItem(Collection!, DocumentID!);
      Navigator.of(c).pop();
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(SnackBar(content: Text(Translation[Language.done])));
    } catch (e) {
      ScaffoldMessenger.of(
        c,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
