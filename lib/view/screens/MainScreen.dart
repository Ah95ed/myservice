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
  bool _updateChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_updateChecked || !mounted) return;
      _updateChecked = true;
      await initData();
      if (mounted) {
        await checkUpdate(context);
      }
    });
  }

  Future<void> checkUpdate(BuildContext context) async {
    final latest = int.tryParse(re) ?? 0;
    final current = int.tryParse(packageInfo?.buildNumber ?? '') ?? 0;
    if (latest > current) {
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
                    final launched = await launchUrl(
                      Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.Blood.types',
                      ),
                      mode: LaunchMode.platformDefault,
                    );
                    if (!launched) {
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
      backgroundColor: Colors.transparent,
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
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorUsed.primary, ColorUsed.DarkGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
          color: AppTheme.nearlyWhite.withOpacity(0.92),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorUsed.primary.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: ColorUsed.DarkGreen.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BottomNavigationBar(
            // backgroundColor: Colors.transparent,
            selectedItemColor: ColorUsed.second,
            unselectedItemColor: ColorUsed.DarkGreen.withOpacity(0.7),
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
      body: Stack(
        children: [
          const _MainBackground(),
          SingleChildScrollView(
            child: SizedBox(
              height: getheight(100),
              width: getWidth(100),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(readSerach.index),
                  child: context.watch<Providers>().bodys[readSerach.index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainBackground extends StatelessWidget {
  const _MainBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorUsed.PrimaryBackground,
            ColorUsed.PrimaryBackground.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: _GlowOrb(
              size: 220,
              color: ColorUsed.second.withOpacity(0.35),
            ),
          ),
          Positioned(
            top: 140,
            right: -60,
            child: _GlowOrb(
              size: 200,
              color: ColorUsed.primary.withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -20,
            child: _GlowOrb(
              size: 260,
              color: ColorUsed.second.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0.0)]),
      ),
    );
  }
}
