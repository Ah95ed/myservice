import 'dart:async';

import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/provider/Provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation _logoAnimation;
  late AnimationController _logoController;
  FirebaseAuth? appAuth = FirebaseAuth.instance;
  @override
  void initState() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoAnimation.addListener(() {
      if (_logoAnimation.status == AnimationStatus.completed) {
        return;
      }
      setState(() {});
    });

    _logoController.forward();
    super.initState();
    startTime();
  }

  Widget _buildLogo() {
    return Center(
      child: SizedBox(
        height: _logoAnimation.value * 250.0,
        width: _logoAnimation.value * 250.0,
        child: Image.asset("assets/logo.png"),
      ),
    );
  }

  Future<void> navigationPage() async {
    context.read<Providers>().managerScreen(MainScreen.ROUTE, context);
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildLogo(),
    );
  }
}
