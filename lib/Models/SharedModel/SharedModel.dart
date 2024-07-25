import 'package:flutter/material.dart';

class SharedModel {
 Future<void> managerScreenSplash(
    String route, BuildContext context, bool f,
      {Object? object}) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (v) {
        return f;
      },
      arguments: object,
    );
  }
 

 
}
