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
