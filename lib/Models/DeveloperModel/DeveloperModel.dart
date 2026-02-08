import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:flutter/material.dart';

class DeveloperModel {
  Future<void> registerInRealTime(
    Map<String, dynamic> data,
    String number,
  ) async {
    try {
      await CloudflareApi.instance.submitEditRequest(data, number);
      Logger.logger('message -> edit request sent');
      ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text(S.current.done_to_send),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      Logger.logger('message registerInRealTime -> $error');
      ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
        SnackBar(
          content: Text('Error Register'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
