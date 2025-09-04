import 'package:Al_Zab_township_guide/Models/UpdateModel/UpdateModel.dart';
import 'package:flutter/material.dart';

class Updateprovider extends ChangeNotifier {
  late UpdateModel model;

  Future<void> sendOtpNumber(BuildContext context, String email) async {
    model = await UpdateModel();
    await model.sendSMS(context, email);
    notifyListeners();
  }

  searchService(String collection, String number, BuildContext ctx) async {
    model = await UpdateModel();

    await model.searchService(collection, number, ctx);
    notifyListeners();
  }

  searchTypes(BuildContext ctx, String number) async {
    model = await UpdateModel();
    await model.searchTypes(ctx, number);
    notifyListeners();
  }

  deleteDataFromRealtimeAndFireStore(BuildContext c) async {
    model = await UpdateModel();
    await model.deleteDataFromRealtimeAndFireStore(c);
    notifyListeners();
  }

  Future deleteDataFromRealtime(BuildContext c, String number) async {
    model = await UpdateModel();
    await model.deletefromrealTime(c, number: number);
    notifyListeners();
  }
}
