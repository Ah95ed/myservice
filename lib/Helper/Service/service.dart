import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? shared;
PackageInfo? packageInfo;
late FirebaseRemoteConfig remoteConfig;
late String re;


Future<void> init() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  shared = await SharedPreferences.getInstance();
  await initLang(shared!.getString('lang') ?? "ar");
  remoteConfig = await FirebaseRemoteConfig.instance;

  await remoteConfig.fetchAndActivate();
  re = await remoteConfig.getString('update');

  packageInfo = await PackageInfo.fromPlatform();
}
