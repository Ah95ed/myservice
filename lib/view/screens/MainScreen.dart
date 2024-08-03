import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE = "MainScreen";
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<MainController>();
    return Scaffold(
      drawer: Customdrawer(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppTheme.nearlyWhite,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getWidth(2),
          vertical: getheight(2.5),
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(5, 18))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            // backgroundColor: Colors.transparent,
            selectedItemColor: ColorUsed.second,
            unselectedItemColor: Colors.black,
            currentIndex: read.index,
            onTap: (index) {
              read.changeSelect(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.medical_information,
                ),
                label: S.current.doctor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_history),
                label: S.of(context).professions,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bloodtype),
                label: S.current.blood_type,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi),
                label: S.current.Cars,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.motorcycle_sharp),
                label: S.current.internal_transfer,
              ),
            ],
          ),
        ),
      ),
      body: context.watch<MainController>().bodys[read.index],
    );
  }
}
