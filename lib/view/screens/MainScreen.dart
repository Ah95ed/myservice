import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE = "MainScreen";
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<MainController>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppTheme.nearlyWhite,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getHight(1.5),
          horizontal: getWidth(0.5),
        ),
        child: GNav(
            selectedIndex: read.index,
            onTabChange: (value) {
              read.changeSelect(value);
            },
            rippleColor: ColorUsed.primary,
            backgroundColor: Colors.transparent.withOpacity(0.2),
            textStyle: TextStyle(color: Colors.white),
            tabBorderRadius: 8,
            curve: Curves.easeOutExpo,
            duration: Duration(milliseconds: 500),
            gap: 0,
            color: ColorUsed.DarkGreen,
            activeColor: Colors.white,
            iconSize: 24,
            tabBackgroundColor: ColorUsed.second,
            padding: EdgeInsets.symmetric(
              horizontal: getWidth(4),
              vertical: getHight(2.5),
            ),
            tabs: [
              GButton(
                icon: Icons.medical_information,
                text: S.of(context).doctor,
              ),
              GButton(
                icon: Icons.work_history,
                text: S.of(context).professions,
              ),
              GButton(
                icon: Icons.bloodtype,
                text: S.of(context).blood_type,
              ),
              GButton(
                icon: Icons.local_taxi,
                text: S.of(context).Cars,
              ),
              GButton(
                icon: Icons.motorcycle_sharp,
                text: S.of(context).Doctor,
              ),
            ]),
      ),
      body: context.watch<MainController>().bodys[read.index],
    );
  }
}
