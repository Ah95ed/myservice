import 'dart:developer';

import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Providers with ChangeNotifier {
  String? name, email, phone, password;
  List s = [];
  List search = [];
  List save = [];
  Widget title = const Text(
    '',
    style: TextStyle(color: AppTheme.notWhite),
  );
  Icon actionsicon = const Icon(Icons.search);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController number = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title = const Text('');
    actionsicon = const Icon(Icons.search);
    notifyListeners();
  }

  late EmailOTP myauth;
  Future registerWithEmailOTP(
    String email,
    String password,
    String name,
    String phone,
    BuildContext context,
  ) async {
    myauth = EmailOTP();
    myauth.setConfig(
        appEmail: 'amhmeed31@gmail.com',
        appName: 'AL Zab Township Guide',
        userEmail: email,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP()) {
      name = name;
      email = email;
      phone = phone;
      password = password;
      managerScreen(OtpScreen.Route, context);
    }

    notifyListeners();
  }

  Future<void> saveRegisterInRealTime() async {}
  Future<bool?> saveData(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    bool t = await prefs.setBool('isRegister', true);
    
    if (t) {
      managerScreenSplash(MainScreen.ROUTE, context, false);
    }
    notifyListeners();
  }

  // bool isRegister = false;

  Future<bool?> checkData() async {
    SharedPreferences prefs = await _prefs;
    bool isRegister = prefs.getBool('isRegister') ?? false;
    notifyListeners();
    return isRegister;
  }

  void changewidget(String titles, TextStyle style) {
    number.text = "";
    if (actionsicon.icon == Icons.search) {
      save = s;
      actionsicon = const Icon(Icons.close);
      title = TextField(
        controller: number,
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.notWhite),
        textAlign: TextAlign.start,
        onChanged: (value) {
          searchName(value);
        },
      );
    } else {
      s = save;
      save = [];
      search = [];
      number.text = "";
      actionsicon = const Icon(Icons.search);
      title = Text(
        titles,
        style: style,
      );
    }
    notifyListeners();
  }

  Future<void> searchName(String? name) async {
    if (name == null) return;

    for (var element in s) {
      if (element['name'].toString().contains(name)) {
        search.add(element);
      }
    }
    s = search;
    search = [];
    notifyListeners();
  }

  Future getData(String collection) async {
    s.clear();
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    final collectionRef = firestoreInstance.collection(collection);
    final querySnapshot = await collectionRef.get();
    s = querySnapshot.docs.map((e) => e).toList();
    notifyListeners();
  }

  void managerScreen(String route, BuildContext context, {Object? object}) {
    Navigator.pushNamed(context, route, arguments: object);
    notifyListeners();
  }

  void managerScreenSplash(String route, BuildContext context, bool f,
      {Object? object}) {
    Navigator.pushNamedAndRemoveUntil(context, route, (v) {
      return f;
    }, arguments: object);
    notifyListeners();
  }

  Future<void> callNumber(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
    notifyListeners();
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
    notifyListeners();
  }
}
