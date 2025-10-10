import 'dart:async';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:Al_Zab_township_guide/controller/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/controller/provider/DeveloperController/DeveloperController.dart';
import 'package:Al_Zab_township_guide/controller/provider/DoctorProvider/DoctorProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/provider/OTPEmailProvider/OTPEmailProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/provider/PdfViewerProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/ScreenSize.dart';
import 'package:Al_Zab_township_guide/view/Size/SizeBuilder.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/screens/BooksScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/GradesScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MyCustomSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  //! runZonedGuarded is a function that allows you to run your app in a zone that catches errors
  await runZonedGuarded<Future<void>>(
    () async {
      await WidgetsFlutterBinding.ensureInitialized();
      await init();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        initData();
      });
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Providers(), lazy: true),
            ChangeNotifierProvider(create: (_) => LoginProvider(), lazy: true),
            ChangeNotifierProvider(create: (_) => SignupProvider(), lazy: true),
            ChangeNotifierProvider(create: (_) => DoctorProvider(), lazy: true),
            ChangeNotifierProvider(create: (_) => MainController(), lazy: true),
            ChangeNotifierProvider(
              create: (_) => LanguageController(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => OTPEmailProvider(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => DeveloperController(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => ServiceController(),
              lazy: true,
            ),
            // Provider for PDF viewer state
            ChangeNotifierProvider(
              create: (_) => PdfViewerProvider(),
              lazy: true,
            ),
            ChangeNotifierProvider(create: (_) => Updateprovider(), lazy: true),
            ChangeNotifierProvider(
              create: (_) => ForgetPasswordProvider(),
              lazy: true,
            ),
          ],
          child: const MyApp(),
          // child: DevicePreview(
          //   enabled: !kReleaseMode,
          //   builder: (context) =>  MyApp(),
          // ),
        ),
      );
    },
    (error, stackTrace) {
      Logger.logger('error: $error || stackTrace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return SizeBuilder(
      baseSize: const Size(375, 812),
      height: context.screenHeight,
      width: context.screenWidth,
      child: Consumer<LanguageController>(
        builder: (context, v, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: v.supportLanguage,
            debugShowCheckedModeBanner: false,
            locale: v.language,
            title: Translation[Language.title],

            routes: routs,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ColorUsed.primary),
              useMaterial3: true,
            ),
            // ! here to check is null or not
            home: shared!.getBool('spalsh') == null
                ? MyCustomSplashScreen()
                // : GradesScreen(),
            : MainScreen(),
            // home : MyCustomSplashScreen(),
          );
        },
      ),
    );
  }

  static BuildContext? getContext() {
    return navigatorKey.currentContext;
  }
}
