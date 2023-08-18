import 'dart:async';
import 'package:flutter/material.dart';
import '../widget/constant/Constant.dart';
import 'login_screen.dart';

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
      seconds: 4,
    );
    return Timer(
      duration,
      loginRoute,
    );
  }

  loginRoute() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
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
              child: Container(
            child: Image.asset("assets/Ichrak.png"),
          ))
        ],
      ),
    );
  }
}
