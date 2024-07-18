import 'dart:async';
import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/constant/Constant.dart';

class SplashScreen extends StatefulWidget {
  static const Route = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(
      seconds: 3,
    );

    return Timer(
      duration,
      loginRoute,
    );
  }

  loginRoute() async {
    final p = context.read<Providers>();
    bool register = true; //await p.checkData() ?? false;

    if (register) {
      p.managerScreenSplash(MainScreen.ROUTE, context, false);
      return;
    } else {
      p.managerScreenSplash(SignupScreen.Route, context, false);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                // color: new Color(0xffF5591F),
                color: ColorUsed.primary, // Color.fromRGBO(80, 16, 99, 1),
                gradient: LinearGradient(colors: [
                  ColorUsed.primary,
                  ColorUsed.second,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Center(
              child: SizedBox(
            height: double.infinity,
            width: 200,
            child: Image.asset("assets/asd.png"),
          ))
        ],
      ),
    );
  }
}
