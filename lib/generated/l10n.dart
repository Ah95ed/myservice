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

  /// `My Service`
  String get title {
    return Intl.message(
      'My Service',
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
