import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/widget/ButtonSelect.dart';
import 'package:Al_Zab_township_guide/Models/constant/Constant.dart';
import 'package:Al_Zab_township_guide/Models/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BloodScreen extends StatelessWidget {
  static const ROUTE = "BloodScreen";
  BloodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppTheme.nearlyWhite,
      resizeToAvoidBottomInset: false,
    
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: ColorUsed.primary,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        transformAlignment: Alignment.center,
        margin: EdgeInsets.only(
          top: getheight(22.0),
          bottom: getheight(22.0),
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
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.A_Plus));
                  },
                ),
                 SizedBox(
                  width: getWidth(4),
                ),
                ButtonSelect(
                  title: Constant.A_Minus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.A_Minus));
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.B_Plus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.B_Plus));
                  },
                ),
                 SizedBox(
                  width: getWidth(4),
                ),
                ButtonSelect(
                  title: Constant.B_Minus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.B_Minus));
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.O_Plus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.O_Plus));
                  },
                ),
                 SizedBox(
                  width: getWidth(4),
                ),
                ButtonSelect(
                  title: Constant.O_Minus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.O_Minus));
                  },
                ),
              ],
            ),
            Row(
              children: [
                ButtonSelect(
                  title: Constant.AB_Plus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.AB_Plus));
                  },
                ),
                 SizedBox(
                  width: getWidth(4),
                ),
                ButtonSelect(
                  title: Constant.AB_Minus,
                  onPressed: () {
                    read.managerScreen(ShowDonors.ROUTE, context,
                        object: DataSend(Constant.AB_Minus));
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
