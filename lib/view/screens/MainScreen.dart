import 'dart:async';
import 'dart:ui';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
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
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const ROUTE = "MainScreen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TutorialCoachMark tutorialCoachMark;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await checkUpdate(context);
    Future.delayed(
      Duration(seconds: 3),
      () {
        if (shared!.getBool('tutorial') == null) {
          createTutorial();
          addItem();
          showTutorial();
        }
      },
    );
  }

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
                          'https://play.google.com/store/apps/details?id=com.Blood.types'),
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: ColorUsed.PrimaryBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: readSerach.title,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            key: menu,
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
          Consumer<Providers>(
            builder: (context, value, child) => 
            IconButton(
              icon: readSerach.actionsicon,
              onPressed: () {
                readSerach.changewidget(TextStyle(
                  fontSize: setFontSize(14),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.notWhite,
                ));
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
            currentIndex: readSerach.index,
            onTap: (index) {
              readSerach.changeSelect(index);
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
                label: S.of(context).cars,
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
      body: SingleChildScrollView(
          child: SizedBox(
        height: getheight(100),
        width: getWidth(100),
        child: context.watch<Providers>().bodys[readSerach.index],
      )),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus> targets = [];

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: ColorUsed.primary,
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
  GlobalKey menu = GlobalKey();
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.desc_doctor,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: setFontSize(18),
                      fontWeight: FontWeight.bold,
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.current.desc_professionals,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: setFontSize(18),
                      fontWeight: FontWeight.bold,
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
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: getheight(8)),
                    child: Text(
                      S.current.desc_donors,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: setFontSize(18),
                        fontWeight: FontWeight.bold,
                      ),
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.current.desc_taxi,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: setFontSize(18),
                      fontWeight: FontWeight.bold,
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.current.desc_transfer,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: setFontSize(18),
                      fontWeight: FontWeight.bold,
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
        identify: "keyBottomNavigation2",
        keyTarget: menu,
        alignSkip: Alignment.bottomCenter,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Translation[Language.desc_more],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: setFontSize(16),
                      fontWeight: FontWeight.bold,
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
