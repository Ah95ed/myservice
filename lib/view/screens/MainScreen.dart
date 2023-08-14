import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:Al_Zab_township_guide/view/widget/ButtonSelect.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';

import '../../Models/provider/Provider.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE = "MainScreen";
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        toolbarHeight: 10.h,
        title: Text(
          S.of(context).Select_Service,
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ).animate().addEffect(
              const MoveEffect(
                begin: Offset(0.0, 10),
                duration: Duration(milliseconds: 500),
                delay: Duration(milliseconds: 200),
                curve: Curves.linear,
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
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
          child: Animate(
            effects: const [
                //      begin: Offset(0.0, 10),
                // duration: Duration(milliseconds: 500),
                // delay: Duration(milliseconds: 200),
                // curve: Curves.linear,
              FadeEffect(
                duration: Duration(milliseconds: 500),
                delay: Duration(milliseconds: 200),
                curve: Curves.linear,
              ),
              MoveEffect(
                begin: Offset(0.0, 10),
              ),
            ],
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
                        context
                            .read<Providers>()
                            .managerScreen(ProfessionsScreen.ROUTE, context);
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
        ),
      ),
    );
  }
}
