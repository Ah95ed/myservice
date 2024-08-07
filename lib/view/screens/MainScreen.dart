import 'dart:ui';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainScreen extends StatefulWidget {
  static const ROUTE = "MainScreen";
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TutorialCoachMark tutorialCoachMark;
  @override
  void initState() {
    if (shared!.getBool('tutorial') == null) {
      Logger.logger('message initState ${shared!.getBool('tutorial')}');
      createTutorial();
      addItem();
      Future.delayed(Duration(milliseconds: 1500), showTutorial);
    }

    super.initState();
  }

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
             key: lang,
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
                key: navdoctor,
                icon: Icon(
                  Icons.medical_information,
                ),
                label: S.of(context).doctor,
              ),
              BottomNavigationBarItem(
                key: work,
                icon: Icon(Icons.work_history),
                label: S.of(context).professions,
              ),
              BottomNavigationBarItem(
                key: donors,
                icon: Icon(Icons.bloodtype),
                label: S.of(context).blood_type,
              ),
              BottomNavigationBarItem(
                key: taxi,
                icon: Icon(Icons.local_taxi),
                label: S.of(context).Cars,
              ),
              BottomNavigationBarItem(
                key: stota,
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

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus> targets = [];
  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.red,
      textSkip: S.current.skip,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        shared!.setBool('tutorial', true);
        Logger.logger('message finish ');
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        Logger.logger("target: $target");

        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  GlobalKey navdoctor = GlobalKey();
  GlobalKey donors = GlobalKey();
  GlobalKey work = GlobalKey();
  GlobalKey taxi = GlobalKey();
  GlobalKey stota = GlobalKey();
  GlobalKey lang = GlobalKey();


  addItem() {
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: navdoctor,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: work,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    //doctor ,work ,donors ,taxi ,stota
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: donors,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    //doctor ,work ,donors ,taxi ,stota
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: taxi,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    //doctor ,work ,donors ,taxi ,stota
 
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: stota,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
       targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: lang,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
