import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:flutter/material.dart';

showCirculerProgress(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    useSafeArea: false,
    context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: AppTheme.notWhite,
        ),
      );
    },
  );
}

showSnakeBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: setFontSize(16),
          fontWeight: FontWeight.bold,
          color: AppTheme.notWhite,
          
        ),
      ),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red[800],
    ),
  );
}
