import 'package:Al_Zab_township_guide/view/screens/AddDoctor/AddDoctor.dart';
import 'package:Al_Zab_township_guide/view/screens/AddSatota/AddSatota.dart';
import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/BooksScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/LineScreen/LineScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:Al_Zab_township_guide/view/screens/MyCustomSplashScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenNumber/OTPScreenNumber.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/AddProfessions/AddProfessions.dart';
import 'package:Al_Zab_township_guide/view/screens/addDonor/AddDonor.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routs = {
  MainScreen.ROUTE: (context) => MainScreen(),
  DoctorScreen.ROUTE: (context) => DoctorScreen(),
  BloodScreen.ROUTE: (context) => BloodScreen(),
  ShowDonors.ROUTE: (context) => const ShowDonors(),
  TheCars.ROUTE: (context) => const TheCars(),
  ProfessionsScreen.ROUTE: (context) => const ProfessionsScreen(),
  SatotaScreen.ROUTE: (context) => const SatotaScreen(),
  SignupScreen.Route: (context) => SignupScreen(),
  LoginScreen.Route: (context) => LoginScreen(),
  MyCustomSplashScreen.Route: (context) => MyCustomSplashScreen(),
  OtpScreenEmail.Route: (context) => OtpScreenEmail(),
  MessageDeveloper.Route: (context) => MessageDeveloper(),
  OTPScreenNumber.Route: (context) => OTPScreenNumber(),
  LineScreen.Route: (context) => LineScreen(),
  AddProfessions.Route: (context) => AddProfessions(),
  AddDoctor.Route: (context) => AddDoctor(),
  AddSatota.Route: (context) => AddSatota(),
  AddDonor.Route: (context) => AddDonor(),
  BooksScreen.route: (context) => BooksScreen(),
};
