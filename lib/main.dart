import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tester_app/view/screens/MainScreen.dart';
import 'package:tester_app/view/screens/DoctorScreen.dart';
import 'package:tester_app/view/screens/BloodScreen.dart';
import 'package:tester_app/view/screens/ProfessionsScreen.dart';
import 'package:tester_app/view/screens/SatotaScreen.dart';
import 'package:tester_app/view/screens/ShowDonors.dart';
import 'package:tester_app/view/screens/TheCars.dart';
import 'Models/provider/Provider.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Providers()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const ROUTE = "MyApp";

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context,orientations,device){
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'Alzab Service',
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          ROUTE: (context) => const MyApp(),
          MainScreen.ROUTE: (context) => const MainScreen(),
          DoctorScreen.ROUTE: (context) => const DoctorScreen(),
          BloodScreen.ROUTE: (context) =>  BloodScreen(),
          ShowDonors.ROUTE: (context) => ShowDonors(),
          TheCars.ROUTE: (context) => const TheCars(),
          ProfessionsScreen.ROUTE: (context) => const ProfessionsScreen(),
          SatotaScreen.ROUTE: (context) =>  SatotaScreen(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      );
    });
   
  }
}

