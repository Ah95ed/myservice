import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'ALZab Township Guide'**
  String get title;

  /// No description provided for @professions.
  ///
  /// In en, this message translates to:
  /// **'Professions'**
  String get professions;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get line;

  /// No description provided for @internal_transfer.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer'**
  String get internal_transfer;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @blood_type.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get blood_type;

  /// No description provided for @cars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @donors.
  ///
  /// In en, this message translates to:
  /// **'Donors'**
  String get donors;

  /// No description provided for @select_service.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get select_service;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name :'**
  String get name;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type :'**
  String get type;

  /// No description provided for @team_policy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service | Privacy Policy'**
  String get team_policy;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time :'**
  String get time;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From :'**
  String get from;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession :'**
  String get profession;

  /// No description provided for @presence.
  ///
  /// In en, this message translates to:
  /// **'Presence'**
  String get presence;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization :'**
  String get specialization;

  /// No description provided for @title_service.
  ///
  /// In en, this message translates to:
  /// **'Title :'**
  String get title_service;

  /// No description provided for @wait_service.
  ///
  /// In en, this message translates to:
  /// **'Waiting Service'**
  String get wait_service;

  /// No description provided for @whocandonate.
  ///
  /// In en, this message translates to:
  /// **'Who Can Donate Blood ?'**
  String get whocandonate;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Go to the source'**
  String get source;

  /// No description provided for @blooddonors.
  ///
  /// In en, this message translates to:
  /// **'Blood Donors :'**
  String get blooddonors;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enter_email;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @don_t_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have Account ?'**
  String get don_t_have_account;

  /// No description provided for @register_now.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get register_now;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forget_password;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enter_password;

  /// No description provided for @number_phone.
  ///
  /// In en, this message translates to:
  /// **'Number Phone'**
  String get number_phone;

  /// No description provided for @already_member.
  ///
  /// In en, this message translates to:
  /// **'Already Member ? '**
  String get already_member;

  /// No description provided for @email_exist.
  ///
  /// In en, this message translates to:
  /// **'Email is Exist  '**
  String get email_exist;

  /// No description provided for @more_options.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get more_options;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @delete_account_browser_notice.
  ///
  /// In en, this message translates to:
  /// **'A secure web page will open to confirm deletion. The link expires soon and can be used once.'**
  String get delete_account_browser_notice;

  /// No description provided for @could_not_open_browser.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser.'**
  String get could_not_open_browser;

  /// No description provided for @edit_Data_and_delete.
  ///
  /// In en, this message translates to:
  /// **'Edit Data and Delete'**
  String get edit_Data_and_delete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @donate_blood.
  ///
  /// In en, this message translates to:
  /// **'Donate Blood'**
  String get donate_blood;

  /// No description provided for @donate_plasma.
  ///
  /// In en, this message translates to:
  /// **'Donate Plasma'**
  String get donate_plasma;

  /// No description provided for @donate_organ.
  ///
  /// In en, this message translates to:
  /// **'Donate Organ'**
  String get donate_organ;

  /// No description provided for @blood.
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get blood;

  /// No description provided for @plasma.
  ///
  /// In en, this message translates to:
  /// **'Plasma'**
  String get plasma;

  /// No description provided for @organ.
  ///
  /// In en, this message translates to:
  /// **'Organ'**
  String get organ;

  /// No description provided for @blood_request.
  ///
  /// In en, this message translates to:
  /// **'Blood Request'**
  String get blood_request;

  /// No description provided for @plasma_request.
  ///
  /// In en, this message translates to:
  /// **'Plasma Request'**
  String get plasma_request;

  /// No description provided for @organ_request.
  ///
  /// In en, this message translates to:
  /// **'Organ Request'**
  String get organ_request;

  /// No description provided for @blood_donation.
  ///
  /// In en, this message translates to:
  /// **'Blood Donation'**
  String get blood_donation;

  /// No description provided for @plasma_donation.
  ///
  /// In en, this message translates to:
  /// **'Plasma Donation'**
  String get plasma_donation;

  /// No description provided for @organ_donation.
  ///
  /// In en, this message translates to:
  /// **'Organ Donation'**
  String get organ_donation;

  /// No description provided for @blood_transfer.
  ///
  /// In en, this message translates to:
  /// **'Blood Transfer'**
  String get blood_transfer;

  /// No description provided for @plasma_transfer.
  ///
  /// In en, this message translates to:
  /// **'Plasma Transfer'**
  String get plasma_transfer;

  /// No description provided for @organ_transfer.
  ///
  /// In en, this message translates to:
  /// **'Organ Transfer'**
  String get organ_transfer;

  /// No description provided for @chanage_lang.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get chanage_lang;

  /// No description provided for @please_select_an_option.
  ///
  /// In en, this message translates to:
  /// **'Please select an Service'**
  String get please_select_an_option;

  /// No description provided for @please_enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Phone'**
  String get please_enter_phone;

  /// No description provided for @please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Name'**
  String get please_enter_name;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Email'**
  String get please_enter_email;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Password'**
  String get please_enter_password;

  /// No description provided for @please_enter_title.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Title'**
  String get please_enter_title;

  /// No description provided for @please_enter_description.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Description'**
  String get please_enter_description;

  /// No description provided for @please_enter_what_you_want.
  ///
  /// In en, this message translates to:
  /// **'Please Enter What You Want'**
  String get please_enter_what_you_want;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @messagedeveloper.
  ///
  /// In en, this message translates to:
  /// **'Message The Developer'**
  String get messagedeveloper;

  /// No description provided for @desctiption_message.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get desctiption_message;

  /// No description provided for @service_type.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get service_type;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @send_developer.
  ///
  /// In en, this message translates to:
  /// **'Send Message To Developer'**
  String get send_developer;

  /// No description provided for @send_request.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get send_request;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @what_you_want.
  ///
  /// In en, this message translates to:
  /// **'What You Want'**
  String get what_you_want;

  /// No description provided for @if_you_need_send_me.
  ///
  /// In en, this message translates to:
  /// **'If you encounter a problem, contact me on social media'**
  String get if_you_need_send_me;

  /// No description provided for @fields.
  ///
  /// In en, this message translates to:
  /// **'One the Field is Empty'**
  String get fields;

  /// No description provided for @done_to_send.
  ///
  /// In en, this message translates to:
  /// **'Done To Send Developer Message '**
  String get done_to_send;

  /// No description provided for @not_phond_found.
  ///
  /// In en, this message translates to:
  /// **'Number Not Found'**
  String get not_phond_found;

  /// No description provided for @go_to_developer_page.
  ///
  /// In en, this message translates to:
  /// **'If you encounter a problem, contact me '**
  String get go_to_developer_page;

  /// No description provided for @desc_doctor.
  ///
  /// In en, this message translates to:
  /// **'Here you will find the names, specializations and numbers of doctors’ clinics in Al-Zab'**
  String get desc_doctor;

  /// No description provided for @desc_professionals.
  ///
  /// In en, this message translates to:
  /// **'Here you will find the names, specializations and numbers of professionals in Al-Zab'**
  String get desc_professionals;

  /// No description provided for @desc_donors.
  ///
  /// In en, this message translates to:
  /// **'Here you find the blood types of donors'**
  String get desc_donors;

  /// No description provided for @desc_taxi.
  ///
  /// In en, this message translates to:
  /// **'here you find name, phone and address of taxi'**
  String get desc_taxi;

  /// No description provided for @desc_transfer.
  ///
  /// In en, this message translates to:
  /// **'Here you find name, phone and address of transfer Only within the borders of Zab '**
  String get desc_transfer;

  /// No description provided for @desc_lang.
  ///
  /// In en, this message translates to:
  /// **'change language'**
  String get desc_lang;

  /// No description provided for @desc_more.
  ///
  /// In en, this message translates to:
  /// **'more options'**
  String get desc_more;

  /// No description provided for @is_number_exist.
  ///
  /// In en, this message translates to:
  /// **'Phone Number is Exist'**
  String get is_number_exist;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @add_service.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get add_service;

  /// No description provided for @checkdata.
  ///
  /// In en, this message translates to:
  /// **'Check Data'**
  String get checkdata;

  /// No description provided for @setlang.
  ///
  /// In en, this message translates to:
  /// **'Set Language'**
  String get setlang;

  /// No description provided for @register_first.
  ///
  /// In en, this message translates to:
  /// **'Register First '**
  String get register_first;

  /// No description provided for @ali.
  ///
  /// In en, this message translates to:
  /// **'Ali'**
  String get ali;

  /// No description provided for @something_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something Wrong'**
  String get something_wrong;

  /// No description provided for @grades_title.
  ///
  /// In en, this message translates to:
  /// **'Academic Grades'**
  String get grades_title;

  /// No description provided for @primary_stage.
  ///
  /// In en, this message translates to:
  /// **'Primary Stage'**
  String get primary_stage;

  /// No description provided for @middle_stage.
  ///
  /// In en, this message translates to:
  /// **'Middle Stage'**
  String get middle_stage;

  /// No description provided for @secondary_stage.
  ///
  /// In en, this message translates to:
  /// **'Secondary Stage'**
  String get secondary_stage;

  /// No description provided for @grade_1_primary.
  ///
  /// In en, this message translates to:
  /// **'1st Primary'**
  String get grade_1_primary;

  /// No description provided for @grade_2_primary.
  ///
  /// In en, this message translates to:
  /// **'2nd Primary'**
  String get grade_2_primary;

  /// No description provided for @grade_3_primary.
  ///
  /// In en, this message translates to:
  /// **'3rd Primary'**
  String get grade_3_primary;

  /// No description provided for @grade_4_primary.
  ///
  /// In en, this message translates to:
  /// **'4th Primary'**
  String get grade_4_primary;

  /// No description provided for @grade_5_primary.
  ///
  /// In en, this message translates to:
  /// **'5th Primary'**
  String get grade_5_primary;

  /// No description provided for @grade_6_primary.
  ///
  /// In en, this message translates to:
  /// **'6th Primary'**
  String get grade_6_primary;

  /// No description provided for @grade_1_middle.
  ///
  /// In en, this message translates to:
  /// **'1st Middle'**
  String get grade_1_middle;

  /// No description provided for @grade_2_middle.
  ///
  /// In en, this message translates to:
  /// **'2nd Middle'**
  String get grade_2_middle;

  /// No description provided for @grade_3_middle.
  ///
  /// In en, this message translates to:
  /// **'3rd Middle'**
  String get grade_3_middle;

  /// No description provided for @grade_4_secondary.
  ///
  /// In en, this message translates to:
  /// **'4th Secondary'**
  String get grade_4_secondary;

  /// No description provided for @grade_5_secondary.
  ///
  /// In en, this message translates to:
  /// **'5th Secondary'**
  String get grade_5_secondary;

  /// No description provided for @grade_6_secondary.
  ///
  /// In en, this message translates to:
  /// **'6th Secondary'**
  String get grade_6_secondary;

  /// No description provided for @scientific.
  ///
  /// In en, this message translates to:
  /// **'Scientific'**
  String get scientific;

  /// No description provided for @literary.
  ///
  /// In en, this message translates to:
  /// **'Literary'**
  String get literary;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
