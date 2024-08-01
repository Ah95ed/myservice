import 'package:Al_Zab_township_guide/Service/Language/Language.dart';
import 'package:flutter/material.dart';

class LanguageController with ChangeNotifier {

    Locale _locale = Locale('ar');

  Locale get locale => _locale;

  Map<String, String> get localizedStrings {
    switch (_locale.languageCode) {
      case 'ar':
        return Language().keyMap['ar']!;
      case 'en':
      default:
        return Language().keyMap['en']!;
    }
  }

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }
  // Locale language = sharedPreferences!.getString("lang") == null
  //     ? const Locale('en')
  //     : Locale(
  //         sharedPreferences!.getString("lang")!,
  //       );

  // void changeLanguage(String? language) {
  //   Locale lang = Locale(language ?? "en");
  //   sharedPreferences!.setString("lang", language!);
  //   notifyListeners();
  // }
}
