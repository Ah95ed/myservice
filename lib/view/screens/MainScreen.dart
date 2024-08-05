import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static const ROUTE = "MainScreen";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final read = context.read<MainController>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Customdrawer(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: ColorUsed.PrimaryBackground,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: ColorUsed.primary,
        elevation: 5,
        toolbarHeight: getheight(10),
        actions: [
          IconButton(
            icon: Icon(
              Icons.language,
              color: AppTheme.notWhite,
              semanticLabel: S.current.line,
            ),
            onPressed: () async {
              final read = context.read<LanguageController>();
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(S.of(context).chanage_lang),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (shared!.getString('lang') == 'en') {
                          Navigator.of(context).pop();
                          return;
                        }
                        read.changeLanguage('en');
                        Navigator.of(context).pop();
                      },
                      child: Text('English'),
                    ),
                    TextButton(
                      onPressed: () {
                         if (shared!.getString('lang') == 'ar') {
                          Navigator.of(context).pop();
                          return;
                        }
                        read.changeLanguage('ar');
                        Navigator.of(context).pop();
                      },
                      child: Text('العربية'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getWidth(2),
          vertical: getheight(2.5),
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 10))
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
                label: S.of(context).doctor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_history),
                label: S.of(context).professions,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bloodtype),
                label: S.of(context).blood_type,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi),
                label: S.of(context).Cars,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.motorcycle_sharp),
                label: S.of(context).internal_transfer,
              ),
            ],
          ),
        ),
      ),
      body: context.watch<MainController>().bodys[read.index],
    );
  }
}
