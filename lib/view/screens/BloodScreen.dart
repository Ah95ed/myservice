import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/widget/ButtonSelect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BloodScreen extends StatefulWidget {
  static const ROUTE = "BloodScreen";
  BloodScreen({super.key});

  @override
  State<BloodScreen> createState() => _BloodScreenState();
}

class _BloodScreenState extends State<BloodScreen> {
  @override
  Widget build(BuildContext context) {
    final read = context.watch<Providers>();

    read.title = Text(
      Translation[Language.selectType],
      style: TextStyle(
        color: AppTheme.notWhite,
        fontSize: setFontSize(16),
        fontWeight: FontWeight.bold,
      ),
    );
    read.actionsicon = const Icon(null);
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,

      body: Container(
        height: getheight(65),
        width: getWidth(100),
        decoration: BoxDecoration(
          border: Border.all(width: 3.0, color: ColorUsed.primary),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        transformAlignment: Alignment.center,
        margin: EdgeInsets.only(
          top: getheight(2),
          bottom: getheight(28.0),
          left: getWidth(2.0),
          right: getWidth(2.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(2),
          vertical: getheight(0.1),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                ButtonSelect(
                  title: Constant.A_Plus,
                  onPressed: () async {
                  await  read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.A_Plus),
                    );
                  },
                ),
                SizedBox(width: getWidth(4)),
                ButtonSelect(
                  title: Constant.A_Minus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.A_Minus),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.B_Plus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.B_Plus),
                    );
                  },
                ),
                SizedBox(width: getWidth(4)),
                ButtonSelect(
                  title: Constant.B_Minus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.B_Minus),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.O_Plus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.O_Plus),
                    );
                  },
                ),
                SizedBox(width: getWidth(4)),
                ButtonSelect(
                  title: Constant.O_Minus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.O_Minus),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.AB_Plus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.AB_Plus),
                    );
                  },
                ),
                SizedBox(width: getWidth(4)),
                ButtonSelect(
                  title: Constant.AB_Minus,
                  onPressed: () {
                    read.managerScreen(
                      ShowDonors.ROUTE,
                      context,
                      object: DataSend(Constant.AB_Minus),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
