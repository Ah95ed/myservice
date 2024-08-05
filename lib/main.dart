

import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/controller/provider/DoctorProvider/DoctorProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MyCustomSplashScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

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
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MainController(),
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
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientations, device) {
        S.load(Locale.fromSubtags(languageCode: 'en'));
        return MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,

          debugShowCheckedModeBanner: false,
          title: S.current.title,
          routes: routs,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorUsed.primary,
            ),
            useMaterial3: true,
          ),
          // home: MainScreen(),
          home:shared!.getBool('spalsh') != null ?MyCustomSplashScreen(): MainScreen()  ,
        );
      },
    );
  }

  static BuildContext? getContext() {
    return navigatorKey.currentContext;
  }
}
