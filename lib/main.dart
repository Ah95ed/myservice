import 'dart:async';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/BloodController/MainController.dart';
import 'package:Al_Zab_township_guide/controller/provider/DeveloperController/DeveloperController.dart';
import 'package:Al_Zab_township_guide/controller/provider/DoctorProvider/DoctorProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/provider/OTPEmailProvider/OTPEmailProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MyCustomSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    await WidgetsFlutterBinding.ensureInitialized();
    await init();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Providers(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => LoginProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => SignupProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => DoctorProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => MainController(),
            lazy: true,
          ),
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
            create: (_) => Updateprovider(),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => ServiceController(),
            lazy: true,
          ),
        ],
        child: MyApp(),
        // child: DevicePreview(
        //   enabled: !kReleaseMode,
        //   builder: (context) =>  MyApp(),
        // ),
      ),
    );
  }, (error, stackTrace) {
   Logger.logger('error: $error || stackTrace: $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
      // update(context);
    return Consumer<LanguageController>(
      builder: (context, v, child) {
        // S.load(
        //   Locale.fromSubtags(
        //     languageCode: shared!.getString('lang') ?? 'ar',
        //   ),
        // );
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorUsed.primary,
            ),
            useMaterial3: true,
          ),
          // home: ShowDonors(),
          home: shared!.getBool('spalsh') == null
              ? MyCustomSplashScreen()
              : MainScreen(),
        );
      },
    );
  }

  static BuildContext? getContext() {
    return navigatorKey.currentContext;
  }


}
