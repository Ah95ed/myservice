import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Services/secure_config.dart';
import 'package:Al_Zab_township_guide/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ⚠️ SharedPreferences للبيانات غير الحساسة فقط
// للبيانات الحساسة، استخدم SecureStorageService بدلاً من ذلك
SharedPreferences? shared;
PackageInfo? packageInfo;
late FirebaseRemoteConfig remoteConfig;
late String re = '0';

Future<void> init() async {
  // تهيئة Shared Preferences (للبيانات غير الحساسة)
  shared = await SharedPreferences.getInstance();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تهيئة الخدمات الأمنية
  await SecureConfig.init();

  // تهيئة اللغة
  await initLang(shared!.getString('lang') ?? "ar");
  
  // معلومات الحزمة
  packageInfo = await PackageInfo.fromPlatform();
}

void initData() async {
  remoteConfig = await FirebaseRemoteConfig.instance;

  await remoteConfig.fetchAndActivate();
  re = await remoteConfig.getString('update');
}

