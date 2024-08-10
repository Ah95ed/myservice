// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ALZab Township Guide`
  String get title {
    return Intl.message(
      'ALZab Township Guide',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Professions`
  String get professions {
    return Intl.message(
      'Professions',
      name: 'professions',
      desc: '',
      args: [],
    );
  }

  /// `Lines`
  String get line {
    return Intl.message(
      'Lines',
      name: 'line',
      desc: '',
      args: [],
    );
  }

  /// `Internal Transfer`
  String get internal_transfer {
    return Intl.message(
      'Internal Transfer',
      name: 'internal_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get doctor {
    return Intl.message(
      'Doctors',
      name: 'doctor',
      desc: '',
      args: [],
    );
  }

  /// `Blood Type`
  String get blood_type {
    return Intl.message(
      'Blood Type',
      name: 'blood_type',
      desc: '',
      args: [],
    );
  }

  /// `Cars`
  String get Cars {
    return Intl.message(
      'Cars',
      name: 'Cars',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get Doctor {
    return Intl.message(
      'Doctor',
      name: 'Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Donors`
  String get donors {
    return Intl.message(
      'Donors',
      name: 'donors',
      desc: '',
      args: [],
    );
  }

  /// `Select Service`
  String get Select_Service {
    return Intl.message(
      'Select Service',
      name: 'Select_Service',
      desc: '',
      args: [],
    );
  }

  /// `Name :`
  String get name {
    return Intl.message(
      'Name :',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Type :`
  String get type {
    return Intl.message(
      'Type :',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service | Privacy Policy`
  String get team_policy {
    return Intl.message(
      'Terms of Service | Privacy Policy',
      name: 'team_policy',
      desc: '',
      args: [],
    );
  }

  /// `Time :`
  String get time {
    return Intl.message(
      'Time :',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `From :`
  String get from {
    return Intl.message(
      'From :',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Profession :`
  String get profession {
    return Intl.message(
      'Profession :',
      name: 'profession',
      desc: '',
      args: [],
    );
  }

  /// `Presence`
  String get presence {
    return Intl.message(
      'Presence',
      name: 'presence',
      desc: '',
      args: [],
    );
  }

  /// `Specialization :`
  String get specialization {
    return Intl.message(
      'Specialization :',
      name: 'specialization',
      desc: '',
      args: [],
    );
  }

  /// `Title :`
  String get title_service {
    return Intl.message(
      'Title :',
      name: 'title_service',
      desc: '',
      args: [],
    );
  }

  /// `Waiting Service`
  String get wait_service {
    return Intl.message(
      'Waiting Service',
      name: 'wait_service',
      desc: '',
      args: [],
    );
  }

  /// `Who Can Donate Blood ?`
  String get whocandonate {
    return Intl.message(
      'Who Can Donate Blood ?',
      name: 'whocandonate',
      desc: '',
      args: [],
    );
  }

  /// `Go to the source`
  String get source {
    return Intl.message(
      'Go to the source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `Blood Donors :`
  String get blooddonors {
    return Intl.message(
      'Blood Donors :',
      name: 'blooddonors',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email`
  String get enter_email {
    return Intl.message(
      'Enter Email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Don't have Account ?`
  String get don_t_have_account {
    return Intl.message(
      'Don\'t have Account ?',
      name: 'don_t_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get register_now {
    return Intl.message(
      'Register Now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password ?`
  String get forget_password {
    return Intl.message(
      'Forget Password ?',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enter_password {
    return Intl.message(
      'Enter Password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Number Phone`
  String get number_phone {
    return Intl.message(
      'Number Phone',
      name: 'number_phone',
      desc: '',
      args: [],
    );
  }

  /// `Already Member ? `
  String get already_member {
    return Intl.message(
      'Already Member ? ',
      name: 'already_member',
      desc: '',
      args: [],
    );
  }

  /// `Email is Exist  `
  String get email_exist {
    return Intl.message(
      'Email is Exist  ',
      name: 'email_exist',
      desc: '',
      args: [],
    );
  }

  /// `More Options`
  String get more_options {
    return Intl.message(
      'More Options',
      name: 'more_options',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Edit Data and Delete`
  String get edit_Data_and_delete {
    return Intl.message(
      'Edit Data and Delete',
      name: 'edit_Data_and_delete',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Donate Blood`
  String get donate_blood {
    return Intl.message(
      'Donate Blood',
      name: 'donate_blood',
      desc: '',
      args: [],
    );
  }

  /// `Donate Plasma`
  String get donate_plasma {
    return Intl.message(
      'Donate Plasma',
      name: 'donate_plasma',
      desc: '',
      args: [],
    );
  }

  /// `Donate Organ`
  String get donate_organ {
    return Intl.message(
      'Donate Organ',
      name: 'donate_organ',
      desc: '',
      args: [],
    );
  }

  /// `Blood`
  String get blood {
    return Intl.message(
      'Blood',
      name: 'blood',
      desc: '',
      args: [],
    );
  }

  /// `Plasma`
  String get plasma {
    return Intl.message(
      'Plasma',
      name: 'plasma',
      desc: '',
      args: [],
    );
  }

  /// `Organ`
  String get organ {
    return Intl.message(
      'Organ',
      name: 'organ',
      desc: '',
      args: [],
    );
  }

  /// `Blood Request`
  String get blood_request {
    return Intl.message(
      'Blood Request',
      name: 'blood_request',
      desc: '',
      args: [],
    );
  }

  /// `Plasma Request`
  String get plasma_request {
    return Intl.message(
      'Plasma Request',
      name: 'plasma_request',
      desc: '',
      args: [],
    );
  }

  /// `Organ Request`
  String get organ_request {
    return Intl.message(
      'Organ Request',
      name: 'organ_request',
      desc: '',
      args: [],
    );
  }

  /// `Blood Donation`
  String get blood_donation {
    return Intl.message(
      'Blood Donation',
      name: 'blood_donation',
      desc: '',
      args: [],
    );
  }

  /// `Plasma Donation`
  String get plasma_donation {
    return Intl.message(
      'Plasma Donation',
      name: 'plasma_donation',
      desc: '',
      args: [],
    );
  }

  /// `Organ Donation`
  String get organ_donation {
    return Intl.message(
      'Organ Donation',
      name: 'organ_donation',
      desc: '',
      args: [],
    );
  }

  /// `Blood Transfer`
  String get blood_transfer {
    return Intl.message(
      'Blood Transfer',
      name: 'blood_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Plasma Transfer`
  String get plasma_transfer {
    return Intl.message(
      'Plasma Transfer',
      name: 'plasma_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Organ Transfer`
  String get organ_transfer {
    return Intl.message(
      'Organ Transfer',
      name: 'organ_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get chanage_lang {
    return Intl.message(
      'Change Language',
      name: 'chanage_lang',
      desc: '',
      args: [],
    );
  }

  /// `Please select an Service`
  String get please_select_an_option {
    return Intl.message(
      'Please select an Service',
      name: 'please_select_an_option',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Phone`
  String get please_enter_phone {
    return Intl.message(
      'Please Enter Phone',
      name: 'please_enter_phone',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Name`
  String get please_enter_name {
    return Intl.message(
      'Please Enter Name',
      name: 'please_enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Email`
  String get please_enter_email {
    return Intl.message(
      'Please Enter Email',
      name: 'please_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Password`
  String get please_enter_password {
    return Intl.message(
      'Please Enter Password',
      name: 'please_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Title`
  String get please_enter_title {
    return Intl.message(
      'Please Enter Title',
      name: 'please_enter_title',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Description`
  String get please_enter_description {
    return Intl.message(
      'Please Enter Description',
      name: 'please_enter_description',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter What You Want`
  String get please_enter_what_you_want {
    return Intl.message(
      'Please Enter What You Want',
      name: 'please_enter_what_you_want',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Message The Developer`
  String get messagedeveloper {
    return Intl.message(
      'Message The Developer',
      name: 'messagedeveloper',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get desctiption_message {
    return Intl.message(
      'Description',
      name: 'desctiption_message',
      desc: '',
      args: [],
    );
  }

  /// `Service Type`
  String get service_type {
    return Intl.message(
      'Service Type',
      name: 'service_type',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Send Message To Developer`
  String get send_developer {
    return Intl.message(
      'Send Message To Developer',
      name: 'send_developer',
      desc: '',
      args: [],
    );
  }

  /// `Send Request`
  String get send_request {
    return Intl.message(
      'Send Request',
      name: 'send_request',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `What You Want`
  String get what_you_want {
    return Intl.message(
      'What You Want',
      name: 'what_you_want',
      desc: '',
      args: [],
    );
  }

  /// `If you encounter a problem, contact me on social media`
  String get if_you_need_send_me {
    return Intl.message(
      'If you encounter a problem, contact me on social media',
      name: 'if_you_need_send_me',
      desc: '',
      args: [],
    );
  }

  /// `One the Field is Empty`
  String get fields {
    return Intl.message(
      'One the Field is Empty',
      name: 'fields',
      desc: '',
      args: [],
    );
  }

  /// `Done To Send Developer Message `
  String get done_to_send {
    return Intl.message(
      'Done To Send Developer Message ',
      name: 'done_to_send',
      desc: '',
      args: [],
    );
  }

  /// `Number Not Found`
  String get not_phond_found {
    return Intl.message(
      'Number Not Found',
      name: 'not_phond_found',
      desc: '',
      args: [],
    );
  }

  /// `If you encounter a problem, contact me `
  String get go_to_developer_page {
    return Intl.message(
      'If you encounter a problem, contact me ',
      name: 'go_to_developer_page',
      desc: '',
      args: [],
    );
  }

  /// `Here you will find the names, specializations and numbers of doctors’ clinics in Al-Zab`
  String get desc_doctor {
    return Intl.message(
      'Here you will find the names, specializations and numbers of doctors’ clinics in Al-Zab',
      name: 'desc_doctor',
      desc: '',
      args: [],
    );
  }

  /// `Here you will find the names, specializations and numbers of professionals in Al-Zab`
  String get desc_professionals {
    return Intl.message(
      'Here you will find the names, specializations and numbers of professionals in Al-Zab',
      name: 'desc_professionals',
      desc: '',
      args: [],
    );
  }

  /// `Here you find the blood types of donors`
  String get desc_donors {
    return Intl.message(
      'Here you find the blood types of donors',
      name: 'desc_donors',
      desc: '',
      args: [],
    );
  }

  /// `here you find name, phone and address of taxi`
  String get desc_taxi {
    return Intl.message(
      'here you find name, phone and address of taxi',
      name: 'desc_taxi',
      desc: '',
      args: [],
    );
  }

  /// `Here you find name, phone and address of transfer Only within the borders of Zab `
  String get desc_transfer {
    return Intl.message(
      'Here you find name, phone and address of transfer Only within the borders of Zab ',
      name: 'desc_transfer',
      desc: '',
      args: [],
    );
  }

  /// `change language`
  String get desc_lang {
    return Intl.message(
      'change language',
      name: 'desc_lang',
      desc: '',
      args: [],
    );
  }

  /// `more options`
  String get desc_more {
    return Intl.message(
      'more options',
      name: 'desc_more',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number is Exist`
  String get is_number_exist {
    return Intl.message(
      'Phone Number is Exist',
      name: 'is_number_exist',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Add Service`
  String get add_service {
    return Intl.message(
      'Add Service',
      name: 'add_service',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
