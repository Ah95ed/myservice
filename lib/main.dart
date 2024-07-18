import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/screens/BloodScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/DoctorScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfessionsScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SatotaScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ShowDonors.dart';
import 'package:Al_Zab_township_guide/view/screens/TheCars.dart';
import 'package:Al_Zab_township_guide/view/screens/WhoCanDonateScreen%20.dart';
import 'package:Al_Zab_township_guide/view/screens/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'view/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Providers(),
        ),
      ],
      child: DevicePreview(enabled: !kReleaseMode,builder: (context) => const MyApp(),)
    ),
  );
}

class MyApp extends StatelessWidget {
  static const ROUTE = "MyApp";

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
          routes: <String, WidgetBuilder>{
            ROUTE: (context) => const MyApp(),
            MainScreen.ROUTE: (context) => const MainScreen(),
            DoctorScreen.ROUTE: (context) => const DoctorScreen(),
            BloodScreen.ROUTE: (context) => BloodScreen(),
            ShowDonors.ROUTE: (context) => const ShowDonors(),
            TheCars.ROUTE: (context) => const TheCars(),
            ProfessionsScreen.ROUTE: (context) => const ProfessionsScreen(),
            SatotaScreen.ROUTE: (context) => const SatotaScreen(),
            SignupScreen.Route: (context) => const SignupScreen(),
            LoginScreen.Route: (context) =>  LoginScreen(),
            SplashScreen.Route: (context) => const SplashScreen(),
            WhoCanDonateScreen.route: (context) => const WhoCanDonateScreen(),
            OtpScreen.Route: (context) => OtpScreen(),
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorUsed.primary,
            ),
            useMaterial3: true,
          ),
          home:  LoginScreen(),
        );
      },
    );
  }
}
