import 'dart:math';

import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Providers with ChangeNotifier {
  String? name, email, phone, password;
  List s = [];
  List search = [];
  // List save = [];

  Widget title = Text(
    Translation[Language.selectType],
    style: TextStyle(color: AppTheme.notWhite),
  );
  Icon actionsicon = const Icon(
    null,
    color: AppTheme.notWhite,
    size: 22.0,
  );

  final TextEditingController number = TextEditingController();
  changewidgetSerach() {
    if (index == 2) {
      title = Text(
        Translation[Language.selectType],
        style: TextStyle(color: AppTheme.notWhite),
      );
      actionsicon = const Icon(
        null,
        color: AppTheme.notWhite,
        size: 22.0,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    number.dispose();
    notifyListeners();
  }

  int index = 2;
  int expanded = 1;

  void changeSelect(int vlaue) {
    index = vlaue;
    changewidgetSerach();
    onSelected();
  }

  void onSelected() {
    this.expanded = 2;
    notifyListeners();
  }

  final bodys = [
    DoctorScreen(),
    ProfessionsScreen(),
    BloodScreen(),
    TheCars(),
    SatotaScreen()
  ];

  List get data => search.isEmpty ? s : search;
  void changewidget(TextStyle style) {
    number.text = "";
    if (actionsicon.icon == Icons.search) {
      // save = List.from(s);
      actionsicon = const Icon(
        Icons.close,
        color: AppTheme.notWhite,
        size: 22.0,
      );
      title = TextField(
        controller: number,
        keyboardType: TextInputType.text,
        style: TextStyle(
            fontSize: setFontSize(14),
            fontWeight: FontWeight.bold,
            color: AppTheme.notWhite),
        textAlign: TextAlign.start,
       
        onChanged: (value) {
        
          searchName(value);
        },
      );
    } else {
      // s = List.from(save);
      // save = [];
      search = [];
      actionsicon = const Icon(
        Icons.search,
        color: AppTheme.notWhite,
        size: 22.0,
      );
      title = Text(
        '',
        style: style,
      );
    }
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  Future registerWithEmailOTP(
    String email,
    String password,
    String name,
    String phone,
    BuildContext context,
  ) async {
    EmailOTP.config(
      appEmail: Constant.appEmail,
      appName: Constant.appName,
      otpLength: 4,
      otpType: OTPType.numeric,
    );
    if (await EmailOTP.sendOTP(email: email)) {
      this.name = name;
      this.email = email;
      this.phone = phone;
      this.password = password;
      managerScreen(OtpScreenEmail.Route, context);
    }

    notifyListeners();
  }

  Future<bool?> checkData() async {
    bool isRegister = shared!.getBool('isRegister') ?? false;
    notifyListeners();
    return isRegister;
  }

  Future<void> searchName(String? name) async {
    if (name == null || name.length == 0 || name == "" || name.isEmpty) {
      search = [];
      // s = save;
      // save = [];
      // search = [];

      notifyListeners();
      return;
    }

    search = s.where((e) {
      return e['name'].contains(name);
    }).toList();
    // for (var element in s) {
    //   if (element['name'].toString().contains(name!)) {
    //     search.add(element);
    //   }
    // }
    // s = search;
    // search = [];
    notifyListeners();
  }

  Future getData(String collection) async {
    s.clear();
    FirebaseFirestore firestoreInstance = await FirebaseFirestore.instance;
    final collectionRef = firestoreInstance.collection(collection);
    final querySnapshot = await collectionRef.get();
    s = await querySnapshot.docs.map((e) {
      return e;
    }).toList();

    notifyListeners();
  }

  managerScreen(String route, BuildContext context, {Object? object}) {
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
    if (await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    )) {
      throw Exception('Could not launch $url');
    }
    notifyListeners();
  }
}
