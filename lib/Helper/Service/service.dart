import 'dart:io';

import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
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
  final hasNetwork = await _hasNetwork();
  if (hasNetwork) {
    await SecureConfig.init();
    re = _safeBuildNumber(SecureConfig.updateBuildNumber);
  } else {
    Logger.logger('Skipping SecureConfig.init() - no internet');
    re = _safeBuildNumber(null);
  }

  // تهيئة اللغة
  await initLang(shared!.getString('lang') ?? "ar");

  // معلومات الحزمة
  packageInfo = await PackageInfo.fromPlatform();
}
Future<void> initData() async {
  await SecureConfig.refresh();
  re = _safeBuildNumber(SecureConfig.updateBuildNumber);
}
String _safeBuildNumber(String? value) {
  if (value == null || value.isEmpty) return '0';
  return value;
}

Future<bool> _hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('one.one.one.one');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
