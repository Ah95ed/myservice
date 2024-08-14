import 'dart:convert';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageController with ChangeNotifier {
  final supportLanguage = [
    const Locale.fromSubtags(languageCode: 'ar'),
    const Locale.fromSubtags(languageCode: 'en'),
  ];

  // Map<String, String> get localizedStrings {
  //   switch (_locale.languageCode) {
  //     case 'ar':
  //       return Language().keyMap['ar']!;
  //     case 'en':
  //     default:
  //       return Language().keyMap['en']!;
  //   }
  // }
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
            await selectLang('en');

    } else {
      await shared!.setString("lang", 'ar');
      language = const Locale('ar');
      // await initLang('ar');
      await selectLang('ar');
    }

    notifyListeners();
  }
}

// abstract class Laninit {
Map Translation = {};
late String language;
initLang(String lang) async {
  if (lang == 'ar') {
    language = await rootBundle.loadString(
      'assets/languages/ar.json',
    );
  } else {
    language = await rootBundle.loadString(
      'assets/languages/en.json',
    );
  }
  Translation = await jsonDecode(language);
  // language = Locale(lang);
}

selectLang(String lang) async {
  if (lang == 'ar') {
    Translation = Language.keyMap['ar']!;
  } else {
    Translation = Language.keyMap['en']!;
  }
  // language = Locale(lang);
}
// }
