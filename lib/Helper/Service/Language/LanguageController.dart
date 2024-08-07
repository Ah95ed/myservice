import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
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
  Locale language = shared!.getString("lang") == null
      ? const Locale('ar')
      : Locale(
          shared!.getString("lang")!,
        );

  

  void changeLanguage(String? lang) async {
   this.language = Locale(lang ?? "ar");
   await shared!.setString("lang", lang!);
    notifyListeners();
  }
}
