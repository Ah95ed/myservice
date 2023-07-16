import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/Constant.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/screens/ShowDonors.dart';
import 'package:tester_app/view/widget/ButtonSelect.dart';

class BloodScreen extends StatelessWidget {
  static const ROUTE = "BloodScreen";
  BloodScreen({super.key});
  final double Hight = 5.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.sp,
        title: Center(
          child: Text(
            S.of(context).blood_type,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: const Color(0xFF5808FB),
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
            SizedBox(
              height: Hight,
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
            SizedBox(
              height: Hight,
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
            SizedBox(
              height: Hight,
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
