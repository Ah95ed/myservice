import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:flutter/material.dart';

class LanguageController with ChangeNotifier {
  final supportLanguage = [
    const Locale.fromSubtags(languageCode: 'ar'),
    const Locale.fromSubtags(languageCode: 'en'),
  ];

  Locale language = shared!.getString("lang") == null
      ? const Locale('ar')
      : Locale(
          shared!.getString("lang")!,
        );

  void changeLanguage(String? lang) async {
    this.language = Locale(lang ?? "ar");
    await shared!.setString("lang", lang!);
    await initLang(lang);
    notifyListeners();
  }
}

class Languages extends ChangeNotifier {
  Locale language = shared!.getString("lang") == null
      ? const Locale('ar')
      : Locale(
          shared!.getString("lang")!,
        );
  // late String translation;
  // String lancode = shared!.getString('lang') ?? 'en';

  void changeLanguage() async {
    //
    if (shared!.getString('lang') == 'ar') {
      await shared!.setString("lang", 'en');
      language = const Locale('en');
      // await initLang('en');
      await initLang('en');
    } else {
      await shared!.setString("lang", 'ar');
      language = const Locale('ar');
      // await initLang('ar');
      await initLang('ar');
    }
    notifyListeners();
  }
}

Map Translation = {};
late String language;

initLang(String lang) async {
  if (lang == 'ar') {
    Translation = Language.keyMap['ar']!;

  } else {
    Translation = Language.keyMap['en']!;

  }

}

