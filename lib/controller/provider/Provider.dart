import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController number = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title = const Text('');
    actionsicon = const Icon(Icons.search);
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

  void changewidget(String titles, TextStyle style) {
    number.text = "";
    if (actionsicon.icon == Icons.search) {
      save = s;
      actionsicon = const Icon(Icons.close);
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

   managerScreen(
    String route
  , BuildContext context
  , {Object? object}) {
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
