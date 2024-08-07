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
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        toolbarHeight: 10.h ,
        title: Text(
          S.of(context).Select_Service,
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
      //! body
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          
          children: [
            Container(
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
                top: 80.0,
                bottom: 120.0,
                left: 16.0,
                right: 16.0,
              ),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Select_Service,
                          style: TextStyle(
                            color: ColorUsed.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      children: [
                        ButtonSelect(
                          title: S.of(context).blood_type,
                          onPressed: () {
                            context
                                .read<Providers>()
                                .managerScreen(BloodScreen.ROUTE, context);
                          },
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        ButtonSelect(
                          title: S.of(context).doctor,
                          onPressed: () {
                            context.read<Providers>().managerScreen(
                                  DoctorScreen.ROUTE,
                                  context,
                                );
                          },
                        ),
                      ],
                    ), // runs after the above w/new duration

                    const SizedBox(
                      height: 48.0,
                    ),
                    Row(
                      children: [
                        ButtonSelect(
                          title: S.of(context).line,
                          onPressed: () {
                            context
                                .read<Providers>()
                                .managerScreen(TheCars.ROUTE, context);
                          },
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        ButtonSelect(
                          title: S.of(context).professions,
                          onPressed: () {
                            context.read<Providers>().managerScreen(
                                ProfessionsScreen.ROUTE, context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    Row(
                      children: [
                        ButtonSelect(
                          title: S.of(context).internal_transfer,
                          onPressed: () {
                            context
                                .read<Providers>()
                                .managerScreen(SatotaScreen.ROUTE, context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              
            ),
         
          ],
        ),
      ),
    );
  }
}
