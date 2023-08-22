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

  /// `Application`
  String get Application {
    return Intl.message(
      'Application',
      name: 'Application',
      desc: '',
      args: [],
    );
  }

  /// `Jummah`
  String get Jummah {
    return Intl.message(
      'Jummah',
      name: 'Jummah',
      desc: '',
      args: [],
    );
  }

  /// `Prayer Timings`
  String get Prayer_Timings {
    return Intl.message(
      'Prayer Timings',
      name: 'Prayer_Timings',
      desc: '',
      args: [],
    );
  }

  /// `Admin message`
  String get Admin_message {
    return Intl.message(
      'Admin message',
      name: 'Admin_message',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get noInternet {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get Fajr {
    return Intl.message(
      'Fajr',
      name: 'Fajr',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise`
  String get Sunrise {
    return Intl.message(
      'Sunrise',
      name: 'Sunrise',
      desc: '',
      args: [],
    );
  }

  /// `Zuhr`
  String get Zuhr {
    return Intl.message(
      'Zuhr',
      name: 'Zuhr',
      desc: '',
      args: [],
    );
  }

  /// `Asr`
  String get Asr {
    return Intl.message(
      'Asr',
      name: 'Asr',
      desc: '',
      args: [],
    );
  }

  /// `Maghreb`
  String get Maghreb {
    return Intl.message(
      'Maghreb',
      name: 'Maghreb',
      desc: '',
      args: [],
    );
  }

  /// `Isha`
  String get Isha {
    return Intl.message(
      'Isha',
      name: 'Isha',
      desc: '',
      args: [],
    );
  }

  /// ` time`
  String get remaining_time {
    return Intl.message(
      ' time',
      name: 'remaining_time',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Sunnah on Friday`
  String get Sunnah_on_Friday {
    return Intl.message(
      'Sunnah on Friday',
      name: 'Sunnah_on_Friday',
      desc: '',
      args: [],
    );
  }

  /// `coming early for Jummah prayer`
  String get coming_early_for_Jummah_prayer {
    return Intl.message(
      'coming early for Jummah prayer',
      name: 'coming_early_for_Jummah_prayer',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `First Hour`
  String get First_Hour {
    return Intl.message(
      'First Hour',
      name: 'First_Hour',
      desc: '',
      args: [],
    );
  }

  /// `Like donating a camel`
  String get Like_donating_a_camel {
    return Intl.message(
      'Like donating a camel',
      name: 'Like_donating_a_camel',
      desc: '',
      args: [],
    );
  }

  /// `Second Hour`
  String get Second_Hour {
    return Intl.message(
      'Second Hour',
      name: 'Second_Hour',
      desc: '',
      args: [],
    );
  }

  /// `Like donating a cow`
  String get Like_donating_a_cow {
    return Intl.message(
      'Like donating a cow',
      name: 'Like_donating_a_cow',
      desc: '',
      args: [],
    );
  }

  /// `Third Hour`
  String get Third_Hour {
    return Intl.message(
      'Third Hour',
      name: 'Third_Hour',
      desc: '',
      args: [],
    );
  }

  /// `like donating a horned ram`
  String get like_donating_a_horned_ram {
    return Intl.message(
      'like donating a horned ram',
      name: 'like_donating_a_horned_ram',
      desc: '',
      args: [],
    );
  }

  /// `Fourth Hour`
  String get Fourth_Hour {
    return Intl.message(
      'Fourth Hour',
      name: 'Fourth_Hour',
      desc: '',
      args: [],
    );
  }

  /// `Like donating a chicken`
  String get Like_donating_a_chicken {
    return Intl.message(
      'Like donating a chicken',
      name: 'Like_donating_a_chicken',
      desc: '',
      args: [],
    );
  }

  /// `Fifth Hour`
  String get Fifth_Hour {
    return Intl.message(
      'Fifth Hour',
      name: 'Fifth_Hour',
      desc: '',
      args: [],
    );
  }

  /// `Like donating an egg`
  String get Like_donating_an_egg {
    return Intl.message(
      'Like donating an egg',
      name: 'Like_donating_an_egg',
      desc: '',
      args: [],
    );
  }

  /// `from`
  String get from {
    return Intl.message(
      'from',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `The Holy Quran`
  String get The_Holy_Quran {
    return Intl.message(
      'The Holy Quran',
      name: 'The_Holy_Quran',
      desc: '',
      args: [],
    );
  }

  /// `Night Prayer`
  String get Night_Prayer {
    return Intl.message(
      'Night Prayer',
      name: 'Night_Prayer',
      desc: '',
      args: [],
    );
  }

  /// `The first part of the night`
  String get The_first_part_of_the_night {
    return Intl.message(
      'The first part of the night',
      name: 'The_first_part_of_the_night',
      desc: '',
      args: [],
    );
  }

  /// `The second part of the night`
  String get The_second_part_of_the_night {
    return Intl.message(
      'The second part of the night',
      name: 'The_second_part_of_the_night',
      desc: '',
      args: [],
    );
  }

  /// `The third part of the night`
  String get The_third_part_of_the_night {
    return Intl.message(
      'The third part of the night',
      name: 'The_third_part_of_the_night',
      desc: '',
      args: [],
    );
  }

  /// `The supplications after prayer`
  String get The_supplications_after_prayer {
    return Intl.message(
      'The supplications after prayer',
      name: 'The_supplications_after_prayer',
      desc: '',
      args: [],
    );
  }

  /// `The remembrances of a Muslim`
  String get The_remembrances_of_a_Muslim {
    return Intl.message(
      'The remembrances of a Muslim',
      name: 'The_remembrances_of_a_Muslim',
      desc: '',
      args: [],
    );
  }

  /// `The morning remembrances`
  String get The_morning_remembrances {
    return Intl.message(
      'The morning remembrances',
      name: 'The_morning_remembrances',
      desc: '',
      args: [],
    );
  }

  /// `The evening remembrances`
  String get The_evening_remembrances {
    return Intl.message(
      'The evening remembrances',
      name: 'The_evening_remembrances',
      desc: '',
      args: [],
    );
  }

  /// `The supplications upon waking up from sleep`
  String get The_supplications_upon_waking_up_from_sleep {
    return Intl.message(
      'The supplications upon waking up from sleep',
      name: 'The_supplications_upon_waking_up_from_sleep',
      desc: '',
      args: [],
    );
  }

  /// `The supplications before ablution (wudu)`
  String get The_supplications_before_ablution {
    return Intl.message(
      'The supplications before ablution (wudu)',
      name: 'The_supplications_before_ablution',
      desc: '',
      args: [],
    );
  }

  /// `The supplications after the Adhan (call to prayer)`
  String get The_supplications_after_the_Adhan {
    return Intl.message(
      'The supplications after the Adhan (call to prayer)',
      name: 'The_supplications_after_the_Adhan',
      desc: '',
      args: [],
    );
  }

  /// `The supplications before sleep`
  String get The_supplications_before_sleep {
    return Intl.message(
      'The supplications before sleep',
      name: 'The_supplications_before_sleep',
      desc: '',
      args: [],
    );
  }

  /// `The supplications after  prayer`
  String get The_supplications_before_and_after_eating {
    return Intl.message(
      'The supplications after  prayer',
      name: 'The_supplications_before_and_after_eating',
      desc: '',
      args: [],
    );
  }

  /// `Radio Holy Quran`
  String get Radio_Holy_Quran {
    return Intl.message(
      'Radio Holy Quran',
      name: 'Radio_Holy_Quran',
      desc: '',
      args: [],
    );
  }

  /// `The General Radio - Varied broadcasting featurin different reciters.`
  String get The_General_Radio_Varied_broadcasting_featurin_different_reciters {
    return Intl.message(
      'The General Radio - Varied broadcasting featurin different reciters.',
      name: 'The_General_Radio_Varied_broadcasting_featurin_different_reciters',
      desc: '',
      args: [],
    );
  }

  /// `For who is the reward for this application?`
  String get For_who_is_the_reward_for_this_application {
    return Intl.message(
      'For who is the reward for this application?',
      name: 'For_who_is_the_reward_for_this_application',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions and Privacy Policy`
  String get Terms_and_Conditions_and_Privacy_Policy {
    return Intl.message(
      'Terms and Conditions and Privacy Policy',
      name: 'Terms_and_Conditions_and_Privacy_Policy',
      desc: '',
      args: [],
    );
  }

  /// `Contact us via email`
  String get Contact_us_via_email {
    return Intl.message(
      'Contact us via email',
      name: 'Contact_us_via_email',
      desc: '',
      args: [],
    );
  }

  /// `Post the link of this application via social media`
  String get Post_the_link_of_this_application_via_social_media {
    return Intl.message(
      'Post the link of this application via social media',
      name: 'Post_the_link_of_this_application_via_social_media',
      desc: '',
      args: [],
    );
  }

  /// `Notices`
  String get Notices {
    return Intl.message(
      'Notices',
      name: 'Notices',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get Notics {
    return Intl.message(
      'Notifications',
      name: 'Notics',
      desc: '',
      args: [],
    );
  }

  /// `Reminder to read Surat Al-Kahf on Friday`
  String get Reminder_to_read_Surat_AlKahf_on_Friday {
    return Intl.message(
      'Reminder to read Surat Al-Kahf on Friday',
      name: 'Reminder_to_read_Surat_AlKahf_on_Friday',
      desc: '',
      args: [],
    );
  }

  /// `Reminder to come early on Friday`
  String get Reminder_to_come_early_on_Friday {
    return Intl.message(
      'Reminder to come early on Friday',
      name: 'Reminder_to_come_early_on_Friday',
      desc: '',
      args: [],
    );
  }

  /// `Remembering to pray in the last hour of Friday`
  String get Remembering_to_pray_in_the_last_hour_of_Friday {
    return Intl.message(
      'Remembering to pray in the last hour of Friday',
      name: 'Remembering_to_pray_in_the_last_hour_of_Friday',
      desc: '',
      args: [],
    );
  }

  /// `Reminders to pray for the Prophet`
  String get Reminders_to_pray_for_the_Prophet {
    return Intl.message(
      'Reminders to pray for the Prophet',
      name: 'Reminders_to_pray_for_the_Prophet',
      desc: '',
      args: [],
    );
  }

  /// `Reminding the Duha prayer`
  String get Reminding_the_Duha_prayer {
    return Intl.message(
      'Reminding the Duha prayer',
      name: 'Reminding_the_Duha_prayer',
      desc: '',
      args: [],
    );
  }

  /// `A reminder to fast on Mondays and Thursdays`
  String get A_reminder_to_fast_on_Mondays_and_Thursdays {
    return Intl.message(
      'A reminder to fast on Mondays and Thursdays',
      name: 'A_reminder_to_fast_on_Mondays_and_Thursdays',
      desc: '',
      args: [],
    );
  }

  /// `Reminder to fast the white days`
  String get Reminder_to_fast_the_white_days {
    return Intl.message(
      'Reminder to fast the white days',
      name: 'Reminder_to_fast_the_white_days',
      desc: '',
      args: [],
    );
  }

  /// `Reminder to do the night prayers`
  String get Reminder_to_do_the_night_prayers {
    return Intl.message(
      'Reminder to do the night prayers',
      name: 'Reminder_to_do_the_night_prayers',
      desc: '',
      args: [],
    );
  }

  /// `Remembering to pray between the call to prayer and the iqama`
  String get Remembering_to_pray_between_the_call_to_prayer_and_the_iqama {
    return Intl.message(
      'Remembering to pray between the call to prayer and the iqama',
      name: 'Remembering_to_pray_between_the_call_to_prayer_and_the_iqama',
      desc: '',
      args: [],
    );
  }

  /// `Reminder to read daily roses from the Holy Quran`
  String get Reminder_to_read_daily_roses_from_the_Holy_Quran {
    return Intl.message(
      'Reminder to read daily roses from the Holy Quran',
      name: 'Reminder_to_read_daily_roses_from_the_Holy_Quran',
      desc: '',
      args: [],
    );
  }

  /// `Remembering the morning and evening remembrances`
  String get Remembering_the_morning_and_evening_remembrances {
    return Intl.message(
      'Remembering the morning and evening remembrances',
      name: 'Remembering_the_morning_and_evening_remembrances',
      desc: '',
      args: [],
    );
  }

  /// `Reminding the entry of prayer times`
  String get Reminding_the_entry_of_prayer_times {
    return Intl.message(
      'Reminding the entry of prayer times',
      name: 'Reminding_the_entry_of_prayer_times',
      desc: '',
      args: [],
    );
  }

  /// `I testify to God Almighty that this application stood for me, my wife, my offspring, my parents, my mother, their parents, my brothers and sisters, our guardians and their offspring, our scholars and their offspring, every Muslim who uses this application, his wife and his offspring, and all dead Muslims`
  String get for_Who {
    return Intl.message(
      'I testify to God Almighty that this application stood for me, my wife, my offspring, my parents, my mother, their parents, my brothers and sisters, our guardians and their offspring, our scholars and their offspring, every Muslim who uses this application, his wife and his offspring, and all dead Muslims',
      name: 'for_Who',
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
