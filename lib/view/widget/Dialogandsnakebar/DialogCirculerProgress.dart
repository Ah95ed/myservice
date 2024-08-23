import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/AddDoctor/AddDoctor.dart';
import 'package:Al_Zab_township_guide/view/screens/AddProfessions/AddProfessions.dart';
import 'package:Al_Zab_township_guide/view/screens/AddSatota/AddSatota.dart';
import 'package:Al_Zab_township_guide/view/screens/LineScreen/LineScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/addDonor/AddDonor.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

Future<void> showSnakeBar(BuildContext context, String message) async {
  await ScaffoldMessenger.of(context).showSnackBar(
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

class CustomDialogAddService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return AlertDialog(
      title: Center(
        child: Text(
          Translation[Language.select_service],
          style: TextStyle(
            fontSize: setFontSize(16),
            fontWeight: FontWeight.bold,
            color: ColorUsed.DarkGreen,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: getheight(0.2),
            color: ColorUsed.DarkGreen,
          ),
          CustomMaterialButton(
            title: Translation[Language.line],
            onPressed: () {
              read.managerScreen(
                LineScreen.Route,
                context,
              );
            },
          ),
          Divider(),
          CustomMaterialButton(
            onPressed: () {
              read.managerScreen(AddProfessions.Route, context);
            },
            title: Translation[Language.professions],
          ),
          Divider(),
          CustomMaterialButton(
            onPressed: () {
              read.managerScreen(AddDoctor.Route, context);
            },
            title: Translation[Language.doctor],
          ),
          Divider(),
          CustomMaterialButton(
            onPressed: () {
              read.managerScreen(AddDonor.Route, context);
            },
            title: Translation[Language.donate],
          ),
          Divider(),
          CustomMaterialButton(
            onPressed: () {
              read.managerScreen(AddSatota.Route, context);
            },
            title: Translation[Language.internal_transfer],
          ),
        ],
      ),
    );
  }
}
