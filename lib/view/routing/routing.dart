import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/EditScreen/EditScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:Al_Zab_township_guide/view/screens/MyCustomSplashScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:Al_Zab_township_guide/view/screens/WhoCanDonateScreen%20.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routs = {
  // ROUTE: (context) => const MyApp(),
  MainScreen.ROUTE: (context) =>  MainScreen(),
  DoctorScreen.ROUTE: (context) =>  DoctorScreen(),
  BloodScreen.ROUTE: (context) => BloodScreen(),
  ShowDonors.ROUTE: (context) => const ShowDonors(),
  TheCars.ROUTE: (context) => const TheCars(),
  ProfessionsScreen.ROUTE: (context) => const ProfessionsScreen(),
  SatotaScreen.ROUTE: (context) => const SatotaScreen(),
  SignupScreen.Route: (context) => SignupScreen(),
  LoginScreen.Route: (context) => LoginScreen(),
  MyCustomSplashScreen.Route: (context) =>  MyCustomSplashScreen(),
  WhoCanDonateScreen.route: (context) => const WhoCanDonateScreen(),
  OtpScreen.Route: (context) => OtpScreen(),
  Editscreen.Route: (context) => const Editscreen(),
  MessageDeveloper.Route: (context) => const MessageDeveloper(),
};
