import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/widget/ButtonSelect.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BloodScreen extends StatelessWidget {
  static const ROUTE = "BloodScreen";
  BloodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        toolbarHeight: 10.h,
        actions: [],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.nearlyWhite,
            size: 24,
          ),
        ),
        title: Text(
          S.of(context).blood_type,
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [ColorUsed.primary, ColorUsed.second],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
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
        margin: const EdgeInsets.only(
            top: 80.0, bottom: 120.0, left: 16.0, right: 16.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ButtonSelect(
                  title: Constant.A_Plus,
                  onPressed: () {
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
                        object: DataSend(Constant.A_Plus));
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ButtonSelect(
                  title: Constant.A_Minus,
                  onPressed: () {
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
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
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
                        object: DataSend(Constant.B_Plus));
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ButtonSelect(
                  title: Constant.B_Minus,
                  onPressed: () {
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
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
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
                        object: DataSend(Constant.O_Plus));
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ButtonSelect(
                  title: Constant.O_Minus,
                  onPressed: () {
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
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
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
                        object: DataSend(Constant.AB_Plus));
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ButtonSelect(
                  title: Constant.AB_Minus,
                  onPressed: () {
                    context.read<Providers>().managerScreen(
                        ShowDonors.ROUTE, context,
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
