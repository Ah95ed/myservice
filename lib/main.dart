import 'dart:developer';

import 'package:Al_Zab_township_guide/controller/Constant/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/splash_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:device_preview/device_preview.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sharedPreferences = await SharedPreferences.getInstance();
  EmailOTP.config(
    appName: S().title,
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'amhmeed31@gmail.com',
    otpLength: 4,
  );
  runApp(
    MultiProvider(
      
      providers: [
        ChangeNotifierProvider(
          create: (_) => Providers(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
          ChangeNotifierProvider(
          create: (_) => SignupProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(),
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(),
      // ),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientations, device) {
        return MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: S().title,
          initialRoute: '/',
          routes: routs,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorUsed.primary,
            ),
            useMaterial3: true,
          ),
          home: SignupScreen(),
        );
      },
    );
  }
}
