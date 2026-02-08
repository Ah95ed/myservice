import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Services/secure_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ⚠️ SharedPreferences للبيانات غير الحساسة فقط
// للبيانات الحساسة، استخدم SecureStorageService بدلاً من ذلك
SharedPreferences? shared;
PackageInfo? packageInfo;
late String re = '0';

Future<void> init() async {
  // تهيئة Shared Preferences (للبيانات غير الحساسة)
  shared = await SharedPreferences.getInstance();

  // تهيئة الخدمات الأمنية
  await SecureConfig.init();

  re = _safeBuildNumber(SecureConfig.updateBuildNumber);

  // تهيئة اللغة
  await initLang(shared!.getString('lang') ?? "ar");

  // معلومات الحزمة
  packageInfo = await PackageInfo.fromPlatform();
}

void initData() async {
  await SecureConfig.refresh();
  re = _safeBuildNumber(SecureConfig.updateBuildNumber);
}

String _safeBuildNumber(String? value) {
  if (value == null || value.isEmpty) return '0';
  return value;
}
