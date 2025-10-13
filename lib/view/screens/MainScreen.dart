import 'dart:async';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const ROUTE = "MainScreen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  FutureOr<void> checkUpdate(BuildContext context) async {
    if (await int.parse(re) > await int.parse(packageInfo!.buildNumber)) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              Translation[Language.update_app],
              style: TextStyle(
                fontSize: setFontSize(16),
                fontWeight: FontWeight.bold,
                color: ColorUsed.DarkGreen,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    Translation[Language.cancel],
                    style: TextStyle(
                      fontSize: setFontSize(14),
                      fontWeight: FontWeight.bold,
                      color: ColorUsed.second,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    if (await launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.Blood.types',
                      ),
                      mode: LaunchMode.platformDefault,
                    )) {
                      throw Exception('Could not launch googleplay');
                    }
                  },
                  child: Text(
                    Translation[Language.update],
                    style: TextStyle(
                      fontSize: setFontSize(14),
                      fontWeight: FontWeight.bold,
                      color: ColorUsed.second,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final readSerach = context.watch<Providers>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Customdrawer(),
      // extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: ColorUsed.PrimaryBackground,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: readSerach.title,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          icon: Icon( Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: ColorUsed.primary,
        elevation: 4,
        toolbarHeight: getheight(10),
        actions: [
          Consumer<Providers>(
            builder: (context, value, child) => IconButton(
              icon: readSerach.actionsicon,
              onPressed: () {
                readSerach.changewidget(
                  TextStyle(
                    fontSize: setFontSize(14),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.notWhite,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getWidth(2),
          vertical: getheight(5),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            // backgroundColor: Colors.transparent,
            selectedItemColor: ColorUsed.second,
            unselectedItemColor: Colors.black,
            currentIndex: readSerach.index,
            onTap: (index) {
              readSerach.changeSelect(index);
            },
            items: [
              BottomNavigationBarItem(
           
                icon: Icon(Icons.medical_information),
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
                label: S.of(context).cars,
              ),
              BottomNavigationBarItem(
         
                icon: Icon(Icons.motorcycle_sharp),
                label: S.of(context).internal_transfer,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: getheight(100),
          width: getWidth(100),
          child: context.watch<Providers>().bodys[readSerach.index],
        ),
      ),
    );
  }

  

}
