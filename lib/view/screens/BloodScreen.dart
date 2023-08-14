import 'package:Al_Zab_township_guide/Models/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/screens/WhoCanDonateScreen%20.dart';
import 'package:Al_Zab_township_guide/view/widget/ButtonSelect.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BloodScreen extends StatelessWidget {
  static const ROUTE = "BloodScreen";
  BloodScreen({super.key});
  final double Hight = 5.h;
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorUsed.primary,
              ColorUsed.second,
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInSine,
      animationDuration: const Duration(milliseconds: 200),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          color: ColorUsed.primary,
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 18.0,
                    bottom: 10.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                ),
                ListTile(
                  onTap: () {
                    context.read<Providers>().managerScreen(
                          WhoCanDonateScreen.route,
                          context,
                        );
                  },
                  leading: const Icon(
                    Icons.star_border_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    S.of(context).whocandonate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    S.of(context).team_policy,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 5.0,
          toolbarHeight: 10.h,
          actions: [
            IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 190),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      color: AppTheme.nearlyWhite,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ).animate().addEffect(
                  const MoveEffect(
                    begin: Offset(0.0, 10),
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  ),
                ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.nearlyWhite,
              size: 24,
            ).animate().addEffect(
                  const MoveEffect(
                    begin: Offset(0.0, 10),
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  ),
                ),
          ),
          title: Text(
            S.of(context).blood_type,
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
          child: Animate(
            effects: const [
                 
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
        ),
      ),
    );
  }
}
