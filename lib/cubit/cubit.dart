import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jumaa/cubit/states.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jumaa/nav_bar.dart';
import 'package:jumaa/service/shared_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pray_times/pray_times.dart';
import 'package:radio_player/radio_player.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart';

import '../component/string_manager.dart';
import '../generated/l10n.dart';
import '../quran/quran_app.dart';
import '../screens/early_pray.dart';
import '../screens/home_screen.dart';
import '../screens/setting.dart';
import '../screens/todo_in_juma.dart';
import '../service/radio_service.dart';

class AppCubit extends Cubit<AppStates> {
  var scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  List<Widget> screens = [
    HomeScreen(),
    ToDoInJuma(),
    EarlyPray(),
    Setting(),
  ];
  var box = GetStorage();

  void changeBottomNavBar(int index) {
    currentIndex = index;
    turnOnAllNotification();
    emit(AppChangeBottomNavBarState());
  }
  var language = 'العربيه';
  var languageCode = 'ar';

  isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }

  currentLanguage() {
    if (isArabic()) {
      language = 'العربيه';
      languageCode = 'ar';
      return 'ar';
    } else
      language = 'English';
    languageCode = 'en';
    return 'en';
  }

  get currentLanguageStr => currentLanguage();

  changeLanguage(value) {
    if (value == 'English') {
      language = 'English';
      Intl.defaultLocale = 'en';
      CacheHelper.putData(key: 'language', value: 'en');
      emit(AppChangeLanguageState());
    } else {
      language = 'العربيه';
      Intl.defaultLocale = 'ar';
      CacheHelper.putData(key: 'language', value: 'ar');
      emit(AppChangeLanguageState());
    }
  }

  final RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  late Future<RadioResponse> radioStations;
  late String radioUrl;

  // ignore: prefer_typing_uninitialized_variables
  static int index = 0;
  String arabicRadio = "https://api.mp3quran.net/radios/radio_arabic.json";
  String englishRadio = "https://api.mp3quran.net/radios/radio_english.json";

  void play() {
    radioPlayer.stateStream.listen((value) {
      isPlaying = value;
      emit(AppRadioState());
    });
    radioPlayer.setChannel(
      title: "Radio Quran",
      url: "https://Qurango.net/radio/mix",
      imagePath: "images/img_rectangle77.png",
    );
  }

  var currentAddress;
  var currentPosition;

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      emit(AppLocationState());
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        emit(AppLocationPermissionErrorState());
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      emit(AppLocationPermissionErrorState());
      return false;
    }
    emit(AppLocationState());
    return true;
  }

  Future getCurrentPosition(BuildContext context) async {
    var hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;

      getAddressFromLatLng(currentPosition!);

      getPrayerTimes(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
      );

      emit(AppLocationSuccessState());
    }).catchError((e) {
      debugPrint(e.toString());
      emit(AppLocationErrorState());
    });
  }
  var address;
  getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'ar');
      List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en');

      Placemark place = placemarks[0];
      currentAddress = "${place.subAdministrativeArea}";
      await box.write('addressAr', currentAddress);
      await box.write('addressEn', placemark[0].subAdministrativeArea);
      isArabic()?address=currentAddress:address=placemark[0].subAdministrativeArea;

      emit(AppGetLocationSuccessState(
          address: currentAddress, position: currentPosition));
    } catch (e) {
      debugPrint(e.toString());
      emit(AppGetLocationErrorState(e.toString()));
    }
  }

  var prayerTimes;
  var prayerNames;

  getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    var now = DateTime.now();
    var timez = now.timeZoneOffset;

    PrayerTimes prayers = PrayerTimes();
    var offsets = [0, 0, 0, 0, 0, 0, 0];
    prayers.tune(offsets);
    prayers.setCalcMethod(prayers.Makkah);
    prayerTimes = prayers.getPrayerTimes(
        now, latitude, longitude, timez.inHours.toDouble());
    //get prayer times in suaid arabia for the current week

    prayerNames = prayers.getTimeNames();

    await box.write('fajr', prayerTimes[0]);
    await box.write('sunrise', prayerTimes[1]);
    await box.write('dhuhr', prayerTimes[2]);
    await box.write('asr', prayerTimes[3]);
    await box.write('sunset', prayerTimes[4]);
    await box.write('maghrib', prayerTimes[5]);
    await box.write('isha', prayerTimes[6]);
    await box.write('prayerNames', prayerNames);
    await box.write('prayerTimes', prayerTimes);

    await box.write(
        'position',
        currentPosition.latitude.toString() +
            ',' +
            currentPosition.longitude.toString());

    calculateJommaHours();
    calculateNightThireds();

    emit(AppGetPrayerTimeSuccessState(
      fajr: prayerTimes[0],
      sunrise: prayerTimes[1],
      dhuhr: prayerTimes[2],
      asr: prayerTimes[3],
      sunset: prayerTimes[4],
      maghrib: prayerTimes[5],
      isha: prayerTimes[6],
    ));
    return prayerTimes;
  }

  defalutPrayerTimes() async {
    PrayerTimes prayers = PrayerTimes();
    var offsets = [0, 0, 0, 0, 0, 0, 0];
    prayers.tune(offsets);
    prayers.setCalcMethod(prayers.Makkah);
    // get prayer times in suaid arabia for the current date

    prayerTimes =
        prayers.getPrayerTimes(DateTime.now(), 24.641176, 46.726024, 3.0);
    prayerNames = prayers.getTimeNames();

    await box.write('fajr', prayerTimes[0]);
    await box.write('sunrise', prayerTimes[1]);
    await box.write('dhuhr', prayerTimes[2]);
    await box.write('asr', prayerTimes[3]);
    await box.write('sunset', prayerTimes[4]);
    await box.write('maghrib', prayerTimes[5]);
    await box.write('isha', prayerTimes[6]);
    await box.write('prayerNames', prayerNames);
    await box.write('prayerTimes', prayerTimes);

    await box.write(
        'position',
        currentPosition.latitude.toString() +
            ',' +
            currentPosition.longitude.toString());

    calculateJommaHours();
    calculateNightThireds();

    emit(AppDefaultPrayerTimeSuccessState());
    return prayerTimes;
  }

  get local => isArabic() ? 'ar' : 'en';
  //time = '5:30'
  // loclaiztion time = '٥:٣٠'

  String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  parsPrayerTime(String time) {
    var timeEn = replaceArabicNumber(time);
    var now = DateTime.now();

    var strTime = timeEn.split(':');
    var hour = int.parse(strTime[0]);
    var minute = int.parse(strTime[1]);
    //PrayerTimeHour pasrsedTime = PrayerTimeHour(hour, minute);

    var stTime = DateTime(now.year, now.month, now.day, hour, minute);
    //var time2=DateFormat('hh:mm', 'en').format(stTime);
    // var pasrsedTime = DateTime.parse(time2);

    return stTime;
  }

  List prayerHours = [];
  int NUM_PRAYER_HOURS = 5;

  calculateJommaHours() async {
    var sunriseT = box.read('sunrise'); // '5:30'
    var dhuhr = box.read('dhuhr'); //'12:08'

    var now = DateTime.now();
    var strSunrise =
        DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + sunriseT;
    var strDhuhr = DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + dhuhr;
    DateTime sunrise = DateTime.parse(strSunrise);
    DateTime noon = DateTime.parse(strDhuhr);
    int totalMinutes = noon.difference(sunrise).inMinutes;
    var hourDuration = (totalMinutes / 5);

    for (int i = 0; i < 5; i++) {
      var hourStart =
      sunrise.add(Duration(minutes: (hourDuration * i).toInt()));
      var hourEnd = hourStart.add(Duration(minutes: hourDuration.toInt()));
      String title = 'Hour ${i + 1}';
      if (i == 4) hourEnd = hourEnd.add(Duration(minutes: -1));

      var hourStartStr = DateFormat('hh:mm', 'en').format(hourStart);
      var hourEndStr = DateFormat('hh:mm', 'en').format(hourEnd);
      await box.write('StartprayerHour$i', hourStartStr);
      await box.write('EndprayerHour$i', hourEndStr);

      prayerHours.add(prayerHours);
      emit(AppGetPrayerHourSuccessState(prayerHours));
    }
  }

  List nightThirds = [];

  // nightThireds()async{
  //   var isha = box.read('isha');
  //   var fajr = box.read('fajr');
  //
  //   var now = DateTime.now();
  //   var strSunset = DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' +
  //       isha; //
  //   var strFajr = DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + fajr;
  //
  //   DateTime sunsetTime = DateTime.parse(strSunset);
  //   DateTime fajrTime = DateTime.parse(strFajr);
  //   int totalMinutes = sunsetTime
  //       .difference(fajrTime)
  //       .inMinutes;
  //   var hourDuration = (totalMinutes ~/ 3);
  //
  //
  // }

  calculateNightThireds() async {
    var sunset = box.read('sunset');
    var fajr = box.read('fajr');

    DateTime sunsetTime = parsPrayerTime(sunset);
    DateTime fajrTime = parsPrayerTime(fajr).add(Duration(days: 1));
    var totalMinutes = fajrTime.difference(sunsetTime).inSeconds;
    var hourDuration = (totalMinutes ~/ 3);
    // print('hourDuration:$hourDuration');
    var hourStart1 = sunsetTime;
    var hourEnd1 = sunsetTime.add(Duration(seconds: hourDuration));

    var hourStart2 = hourEnd1.add(Duration(seconds: 60));
    var hourEnd2 = hourStart2.add(Duration(seconds: hourDuration));

    var hourStart3 = hourEnd2.add(Duration(seconds: 60));
    var hourEnd3 = fajrTime;

    var hourStartStr1 = DateFormat('hh:mm', 'en').format(hourStart1);
    var hourEndStr1 = DateFormat('hh:mm', 'en').format(hourEnd1);
    await box.write('StartNightThirds1', hourStartStr1);
    await box.write('EndNightThirds1', hourEndStr1);
    var hourStartStr2 = DateFormat('hh:mm', 'en').format(hourStart2);
    var hourEndStr2 = DateFormat('hh:mm', 'en').format(hourEnd2);
    await box.write('StartNightThirds2', hourStartStr2);
    await box.write('EndNightThirds2', hourEndStr2);
    var hourStartStr3 = DateFormat('hh:mm', 'en').format(hourStart3);
    var hourEndStr3 = DateFormat('hh:mm', 'en').format(hourEnd3);
    await box.write('StartNightThirds3', hourStartStr3);
    await box.write('EndNightThirds3', hourEndStr3);

    emit(AppGetNightThirdSuccessState(nightThirds));
  }

  Timer? countdownTimer;
  Duration myDuration = Duration(days: 5);

  String strDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  var days;

  // Step 7
  var hours;

  var minutes;
  var seconds;

  var streamDuration;

  bool isPassed = false;

  Duration getLeftTime(prayerTim) {
    var now = DateTime.now();
    var strPrayerTime =
        '${DateFormat('yyyy-MM-dd', 'en').format(now)} ' + prayerTim;
    var prayerTime = DateTime.parse(strPrayerTime);
    var difference = prayerTime.difference(now);
    if (difference.isNegative) {
      isPassed = true;
      difference = Duration(days: 1) + difference;
    }
    streamDuration = StreamDuration(difference);

    return difference;
  }
  // static Future<List<NotificationPermission>> requestUserPermissions(
  //     BuildContext context,{
  //       // if you only intends to request the permissions until app level, set the channelKey value to null
  //       required String? channelKey,
  //       required List<NotificationPermission> permissionList}
  //     ) async {
  //
  //   // Check if the basic permission was conceived by the user
  //   // if(!await requestBasicPermissionToSendNotifications(context))
  //   //   return [];
  //
  //   // Check which of the permissions you need are allowed at this time
  //   List<NotificationPermission> permissionsAllowed = await AwesomeNotifications().checkPermissionList(
  //       channelKey: channelKey,
  //       permissions: permissionList
  //   );
  //
  //   // If all permissions are allowed, there is nothing to do
  //   if(permissionsAllowed.length == permissionList.length)
  //     return permissionsAllowed;
  //
  //   // Refresh the permission list with only the disallowed permissions
  //   List<NotificationPermission> permissionsNeeded =
  //   permissionList.toSet().difference(permissionsAllowed.toSet()).toList();
  //
  //   // Check if some of the permissions needed request user's intervention to be enabled
  //   List<NotificationPermission> lockedPermissions = await AwesomeNotifications().shouldShowRationaleToRequest(
  //       channelKey: channelKey,
  //       permissions: permissionsNeeded
  //   );
  //
  //   // If there is no permissions depending on user's intervention, so request it directly
  //   if(lockedPermissions.isEmpty){
  //
  //     // Request the permission through native resources.
  //     await AwesomeNotifications().requestPermissionToSendNotifications(
  //         channelKey: channelKey,
  //         permissions: permissionsNeeded
  //     );
  //
  //     // After the user come back, check if the permissions has successfully enabled
  //     permissionsAllowed = await AwesomeNotifications().checkPermissionList(
  //         channelKey: channelKey,
  //         permissions: permissionsNeeded
  //     );
  //   }
  //   else {
  //     // If you need to show a rationale to educate the user to conceived the permission, show it
  //     await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           backgroundColor: Color(0xfffbfbfb),
  //           title: Text('Awesome Notifications needs your permission',
  //             textAlign: TextAlign.center,
  //             maxLines: 2,
  //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Image.asset(
  //                 'assets/images/animated-clock.gif',
  //                 height: MediaQuery.of(context).size.height * 0.3,
  //                 fit: BoxFit.fitWidth,
  //               ),
  //               Text(
  //                 'To proceed, you need to enable the permissions above'+
  //                     (channelKey?.isEmpty ?? true ? '' : ' on channel $channelKey')+':',
  //                 maxLines: 2,
  //                 textAlign: TextAlign.center,
  //               ),
  //               SizedBox(height: 5),
  //               Text(
  //                 lockedPermissions.join(', ').replaceAll('NotificationPermission.', ''),
  //                 maxLines: 2,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //               ),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: (){ Navigator.pop(context); },
  //                 child: Text(
  //                   'Deny',
  //                   style: TextStyle(color: Colors.red, fontSize: 18),
  //                 )
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //
  //                 // Request the permission through native resources. Only one page redirection is done at this point.
  //                 await AwesomeNotifications().requestPermissionToSendNotifications(
  //                     channelKey: channelKey,
  //                     permissions: lockedPermissions
  //                 );
  //
  //                 // After the user come back, check if the permissions has successfully enabled
  //                 permissionsAllowed = await AwesomeNotifications().checkPermissionList(
  //                     channelKey: channelKey,
  //                     permissions: lockedPermissions
  //                 );
  //
  //                 Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'Allow',
  //                 style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         )
  //     );
  //   }
  //
  //   // Return the updated list of allowed permissions
  //   return permissionsAllowed;
  // }
  //
  // cancel(int i) {
  //   AwesomeNotifications().cancel(i);
  //   emit(CancelNotificationState());
  // }
  //
  // initializeNotification(
  //     BuildContext context,
  //     ) async {
  //   AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //     if (!isAllowed) {
  //       requestUserPermissions(context,
  //           channelKey: 'daily channel',
  //           permissionList: [
  //             NotificationPermission.Vibration,
  //             NotificationPermission.Light,
  //             NotificationPermission.Sound,
  //             NotificationPermission.Alert,
  //             NotificationPermission.Badge,
  //           ]);
  //     }
  //   });
  //
  //
  //   emit(InitializeNotificationState());
  // }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize notification
  initializeNotification() async {
    // await init();

    _configureLocalTimeZone();
    // const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/launcher_icon");
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    checkAndroid();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    emit(InitializeNotificationState());
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(
      int hour, int minutes, int day,int month,int year, bool repeatWeekly, bool repeatDaily) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minutes,
    );
    // if (day==DateTime.now().add(Duration(days: 20)).day) {
    // if (scheduleDate.isBefore(now)) {
    //   scheduleDate = scheduleDate.add(Duration(days: 30));
    // }
    // }
    emit(SetTimeNotificationState());

    return scheduleDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    //get time zone location from device
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  //Scheduled Notification
  scheduledNotification({
    required int hour,
    required int minutes,
    required int day,
    required int month,
    required int year,
    required int id,
    required String title,
    required String body,
    required bool weekly,
    required bool daily,
    //required String sound,
  }) async {
    emit(ScheduledNotificationLoadingState());
    var time = _convertTime(hour, minutes, day,month,year, weekly, daily);

    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      body,
      time,
      NotificationDetails(
        android: AndroidNotificationDetails(
          //'your channel id $sound',
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          //sound: RawResourceAndroidNotificationSound(sound),
          icon: "@mipmap/launcher_icon",
          largeIcon: DrawableResourceAndroidBitmap("@mipmap/launcher_icon"),

          playSound: true,
        ),
        //iOS: IOSNotificationDetails(sound: '$sound.mp3'),
      ),

      //androidAllowWhileIdle: false,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents:
      // weekly? DateTimeComponents.dayOfWeekAndTime :
      // DateTimeComponents.time,
      payload: 'payload',
    )
        .then((value) {
      emit(ScheduledNotificationSuccessState());
      debugPrint(
          'title:$title ==>day: $day/$month/$year ==>time:$hour:$minutes ==>id:$id  Notification scheduled');
    }).catchError((error) {
      emit(ScheduledNotificationErrorState(error.toString()));
      debugPrint('$error');
      debugPrint(
          'title:$title ==>day:$day/$month/$year ==>time:$hour:$minutes ==>id:$id ===> Notification scheduled error');
    });
  }


  scheduledNotificationV2({
    required int hour,
    required int minutes,
    required int day,
    required int month,
    required int year,
    required int id,
    required String title,
    required String body,
    required bool weekly,
    required bool daily,
    //required String sound,
  }) async {
    emit(ScheduledNotificationLoadingState());
    var time = _convertTime(hour, minutes, day,month,year, weekly, daily);

    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      body,
      time,
      NotificationDetails(
        android: AndroidNotificationDetails(
          //'your channel id $sound',
          'chanel 2',
          'daily chanel',
          channelDescription: 'daily chanel description v2',
          importance: Importance.max,
          priority: Priority.high,
          //sound: RawResourceAndroidNotificationSound(sound),
          icon: "@mipmap/launcher_icon",
          largeIcon: DrawableResourceAndroidBitmap("@mipmap/launcher_icon"),

          playSound: true,
        ),
        //iOS: IOSNotificationDetails(sound: '$sound.mp3'),
      ),

      //androidAllowWhileIdle: false,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents:
      // weekly? DateTimeComponents.dayOfWeekAndTime :
      // DateTimeComponents.time,
      payload: 'payload',
    )
        .then((value) {
      emit(ScheduledNotificationSuccessState());
      debugPrint(
          'daily chanel ====> title:$title ==>day: $day==>time:$hour:$minutes ==>id:$id  Notification scheduled');
    }).catchError((error) {
      emit(ScheduledNotificationErrorState(error.toString()));
      debugPrint('$error');
      debugPrint(
          'daily chanel ====> title:$title ==>day: $day==>time:$hour:$minutes ==>id:$id ===> Notification scheduled error');
    });
  }

// Helper function to get the next instance of Friday at 10:00 AM
  tz.TZDateTime? _nextInstanceOfFridayTenAM(
      int day,int month,int year,int hour,int minute,
      ) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime? scheduledDate =
    tz.TZDateTime(tz.local, year, month, day, hour, minute);

    // while (scheduledDate.weekday != day) {
    //  // get the day at next week if the day is passed
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }
    if (scheduledDate.isBefore(now) ) {
      //skip this week if the day is passed
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

//   weeklyTime(
//   {
//     required int hour,
//     required int minutes,
//     required int day,
//     required int i,
//
// }
//       ){
//     tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     var time = _nextInstanceOfFridayTenAM(day,now.month,now.year, hour, minutes,).add(Duration(days: i * 7));
//     return time;
//   }

  // secheduledWeeklyNotification
  secheduledWeeklyNotification({
    required int hour,
    required int minutes,
    required int day,
    required int month,
    required int year,
    required int id,
    required String title,
    required String body,
    required bool weekly,

    required bool daily,
    tz.TZDateTime? time,
    int i = 0,
  }) async {
    //tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    var time = _nextInstanceOfFridayTenAM(day,month,year, hour, minutes,);
    var androidDetails = AndroidNotificationDetails(
      'sechudle id',
      'sechudleChanel',
      channelDescription: 'channelDescription weekly',
      playSound: true,
      icon: '@mipmap/launcher_icon',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      priority: Priority.high,
      importance: Importance.max,
    );

    var generalNotificationDetails =
    NotificationDetails(android: androidDetails);
    flutterLocalNotificationsPlugin
        .zonedSchedule(
      id,
      title,
      body,
      time!,
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidAllowWhileIdle: false,
    )
        .then((value) {
      emit(ScheduledNotificationSuccessState());
      debugPrint('$title ==>day : ${time.weekday} ==> date:${time.day}/${time.month}/${time.year} ==>{$time} ==>Weekly Notification scheduled');
    }).catchError((error) {
      emit(ScheduledNotificationErrorState(error.toString()));
      debugPrint('$error');
      debugPrint('$title ==>day : ${time.weekday} ==> date:${time.day}/${time.month}/${time.year} ==>Weekly Notification scheduled error');
    });

    emit(ScheduledNotificationLoadedState());
  }

  /// Request IOS permissions
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    emit(RequestIOSPermissionState());
  }

  cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    emit(CancelAllNotificationState());
  }

  cancel(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    emit(CancelNotificationState());
  }

  Future onSelectNotification(String payload) async {
    debugPrint('Notification clicked');
    emit(OnSelectNotificationState());
    return Future.value(0);
  }

  // void onDidReceiveLocalNotification(int id, String title, String body,
  //     String payload, BuildContext context) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //             title: Text(title),
  //             content: Text(body),
  //             actions: [
  //               CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 child: Text('Ok'),
  //                 onPressed: () async {
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                   await Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => quranApp()),
  //                   );
  //                 },
  //               )
  //             ],
  //           ));
  //   void removeReminder(int notificationId) {
  //     flutterLocalNotificationsPlugin.cancel(notificationId);
  //   }
  // }

  /// must call it from view after getContext is initialized to show dialog message
  checkAndroid() async {
    if (!(await Permission.notification.request().isGranted) &&
        Platform.isAndroid) {
      debugPrint('Permission not granted');
      openAppSettings();
      emit(PermissionNotGrantedState());
    } else {
      requestIOSPermissions();
      debugPrint('Permission granted');
      emit(PermissionGrantedState());
    }
  }

// execute if app in background
  Future<void> _messageHandler(RemoteMessage message) async {
    // Data notificationMessage = Data.fromJson(message.data);
    debugPrint('notification from background : ${message.toMap()}');
    debugPrint('notification from background : ${message.data}');
    emit(OnDidReceiveLocalNotificationResponseState());
  }

//   scheduledNotification({
//     required int hour,
//     required int minutes,
//     required int day,
//     required int id,
//     required String title,
//     required String body,
//     required bool weekly,
//     required bool daily,
// })async{
//     AwesomeNotifications().createNotification(content:
//
//     NotificationContent(
//       id: id,
//       channelKey: 'daily channel',
//       title: title,
//       body: body,
//       notificationLayout: NotificationLayout.BigPicture,
//       displayOnBackground: true,
//       displayOnForeground: true,
//       largeIcon: 'asset://images/logo',
//       bigPicture: 'asset://images/logo',
//
//
//
//
//
//
//
//
//
//     ),
//
// schedule: NotificationCalendar().fromMap(
//   {
//     "allowWhileIdle": true,
//     "day": day,
//     "hour": hour,
//     "minute": minutes,
//     "month": DateTime.now().month,
//     "second": 0,
//     "timeZone": DateTime.now().timeZoneName,
//     "weekday": DateTime.now().weekday,
//     "year": DateTime.now().year,
//   }
// ),
//
//     // schedule: NotificationCalendar(
//     //   hour: hour,
//     //   minute: minutes,
//     //
//     //  // day: day,
//     //   timeZone: DateTime.now().timeZoneName,
//     //   allowWhileIdle: true,
//     //   repeats: true,
//     //
//     // )
//     ).then((value) {
//       debugPrint('notification created');
//       emit(NotificationSecheduledState());
//     }).catchError((onError){
//       debugPrint('notification error');
//       emit(NotificationSecheduledState());
//     });
//     emit(NotificationSecheduledState());
//
// }


  //getNextFriday
  getNextFriday() {
    var now = DateTime.now();
    var friday = now.weekday == 5
        ? now
        : now.add(Duration(days: 5 - now.weekday));
    return friday;
  }

  getNetSunday() {
    var now = DateTime.now();
    var sunday = now.weekday == 7
        ? now
        : now.add(Duration(days: 7 - now.weekday));
    return sunday;
  }

  getNextWednesday() {
    var now = DateTime.now();
    var wednesday = now.weekday == 3
        ? now
        : now.add(Duration(days: 3 - now.weekday));
    return wednesday;
  }

  getThursday(){
    var now = DateTime.now();
    var wednesday = now.weekday == 4
        ? now
        : now.add(Duration(days: 4 - now.weekday));
    return wednesday;
  }

  // getSaturday() {
  //   var now = DateTime.now();
  //   var saturday = now.weekday == 6
  //       ? now
  //       : now.add(Duration(days: 6 - now.weekday));
  //   return saturday;
  // }
  //
  // testWeeklyNotification(){
  //   var sat = getSaturday();
  //   var time=_nextInstanceOfFridayTenAM(sat.day, sat.month, sat.year, DateTime.now().hour, DateTime.now().add(Duration(minutes: 1)).minute,);
  //   secheduledWeeklyNotification(hour: time.hour, minutes: time.minute, day: time.day, month: time.month, year: time.year, id: 2000, title: "Test Weekly Notification", body: '😀😀😀', weekly: true, daily: true);
  //   emit(TestWeeklyNotificationState());
  // }


  surahElKahfNotification({
    required int i,
    required int id,
  }) {
    var friday = getNextFriday();


    var time = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year, parsPrayerTime(box.read('dhuhr')).subtract(Duration(hours: 1)).hour, parsPrayerTime(box.read('dhuhr')).subtract(Duration(hours: 1)).minute);
    if(time!=null){
      time=time.add(Duration(days: i * 7));

      secheduledWeeklyNotification(
          month: time.month,
          year: time.year,
          hour:time.hour,
          // parsPrayerTime(box.read('dhuhr')).subtract(Duration(hours: 1)).hour,
          minutes:time.minute,
          // parsPrayerTime(box.read('dhuhr'))
          //     .subtract(Duration(hours: 1))
          //     .minute,
          day: time.day,

          id: id+i,
          title: 'سورة الكهف',
          body: 'قراءة سورة الكهف ',
          weekly: true,
          daily: false,
          i: i);
    }

    emit(SurahElkahfNotificationState());
  }

  earlyJoumaHourNotification({
    required int i,
    required int id,

  }) {
    var friday = getNextFriday();
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var time1 = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year,parsPrayerTime(box.read('StartprayerHour0')).hour, parsPrayerTime(box.read('StartprayerHour0')).minute,);
    var time2 = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year,parsPrayerTime(box.read('EndprayerHour0')).hour, parsPrayerTime(box.read('EndprayerHour0')).minute,);
    var time3 = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year,parsPrayerTime(box.read('EndprayerHour1')).hour, parsPrayerTime(box.read('EndprayerHour1')).minute,);
    var time4 = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year,parsPrayerTime(box.read('EndprayerHour2')).hour, parsPrayerTime(box.read('EndprayerHour2')).minute,);
    var time5 = _nextInstanceOfFridayTenAM(friday.day,friday.month,friday.year,parsPrayerTime(box.read('EndprayerHour3')).hour, parsPrayerTime(box.read('EndprayerHour3')).minute,);
    if(time1!=null) {
      time1=time1.add(Duration(days: i * 7));
      secheduledWeeklyNotification(

          month: time1.month,
          year: time1.year,

          hour: box.read('StartprayerHour0') != null
              ? parsPrayerTime(box.read('StartprayerHour0')).hour
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise')).hour
              : 6,
          minutes: box.read('StartprayerHour0') != null
              ? parsPrayerTime(box.read('StartprayerHour0')).minute
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise')).minute
              : 0,
          day: time1.day,
          id: id,
          title: 'الساعه الأولي',
          body: 'كمن قرب بدنه',
          weekly: true,
          daily: false,
          i: i);
    }
    if(time2!=null) {
      time2=time2.add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: box.read('StartprayerHour1') != null
              ? parsPrayerTime(box.read('StartprayerHour1')).hour
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 1, minutes: 34))
              .hour
              : 7,
          minutes: box.read('StartprayerHour1') != null
              ? parsPrayerTime(box.read('StartprayerHour1')).minute
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 1, minutes: 34))
              .minute
              : 0,
          day: time2.day,
          month: time2.month,
          year: time2.year,
          id: id + 1,
          title: 'الساعه الثانيه',
          body: 'كمن قرب بقرة',
          weekly: true,
          daily: false,
          i: i);
    }
    if(time3!=null) {
      time3=time3.add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: box.read('StartprayerHour2') != null
              ? parsPrayerTime(box.read('StartprayerHour2')).hour
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 3, minutes: 8))
              .hour
              : 9,
          minutes: box.read('StartprayerHour2') != null
              ? parsPrayerTime(box.read('StartprayerHour2')).minute
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 3, minutes: 8))
              .minute
              : 0,
          day: time3.day,
          month: time3.month,
          year: time3.year,
          id: id + 2,
          title: 'الساعه الثالثه',
          body: 'كمن قرب كبش اقرن',
          weekly: true,
          daily: false,
          i: i);
    }
    if(time4!=null) {
      time4=time4.add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: box.read('StartprayerHour3') != null
              ? parsPrayerTime(box.read('StartprayerHour3')).hour
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 4, minutes: 42))
              .hour
              : 10,
          minutes: box.read('StartprayerHour3') != null
              ? parsPrayerTime(box.read('StartprayerHour3')).minute
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 4, minutes: 42))
              .minute
              : 0,
          day: time4.day,
          month: time4.month,
          year: time4.year,
          id: id + 3,
          title: 'الساعه الرابعه',
          body: 'كمن قرب دجاجة',
          weekly: true,
          daily: false,
          i: i);
    }
    if(time5!=null) {
      time5=time5.add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: box.read('StartprayerHour4') != null
              ? parsPrayerTime(box.read('StartprayerHour4')).hour
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 6, minutes: 16))
              .hour
              : 12,
          minutes: box.read('StartprayerHour4') != null
              ? parsPrayerTime(box.read('StartprayerHour4')).minute
              : box.read('sunrise') != null
              ? parsPrayerTime(box.read('sunrise'))
              .add(Duration(hours: 6, minutes: 16))
              .minute
              : 0,
          day: time5.day,
          month: time5.month,
          year: time5.year,
          id: id + 4,
          title: 'الساعه الخامسه',
          body: 'كمن قرب بيضة',
          weekly: true,
          daily: false,
          i: i);
    }
    emit(EarlyJoumaHourNotificationState());
  }

  nightPrayerNotification({required day ,required int month,required int year, required id}) {
    scheduledNotification(
      hour: box.read('StartNightThirds3') != null
          ? parsPrayerTime(box.read('StartNightThirds3')).hour
          : 2,
      minutes: box.read('StartNightThirds3') != null
          ? parsPrayerTime(box.read('StartNightThirds3')).minute
          : 0,
      day: day,
      month: month,
      year: year,
      id: id,
      title: 'الثلث الاخير من الليل',
      body: 'قم وناجي الرحمن',
      weekly: false,
      daily: true,
    );

    emit(NightPrayerNotificationState());
  }

  mondayThursdayNotification({
    required int i,
    required int id,
  }) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);


    var monday=getNetSunday();
    var thursday=getNextWednesday();
    var timeMonday= _nextInstanceOfFridayTenAM(monday.day,monday.month,monday.year, parsPrayerTime(box.read('maghrib')).add(Duration(hours: 1)).hour, parsPrayerTime(box.read('maghrib'))
        .add(Duration(hours: 1))
        .minute,)
    ;
    var timeThursday= _nextInstanceOfFridayTenAM(thursday.day,thursday.month,thursday.year, parsPrayerTime(box.read('maghrib')).add(Duration(hours: 1)).hour, parsPrayerTime(box.read('maghrib'))
        .add(Duration(hours: 1))
        .minute,);

    if(timeMonday!=null) {
      timeMonday=timeMonday .add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: box.read('maghrib') != null
              ? parsPrayerTime(box.read('maghrib'))
              .add(Duration(hours: 1))
              .hour
              : 18,
          minutes: box.read('maghrib') != null
              ? parsPrayerTime(box.read('maghrib'))
              .add(Duration(hours: 1))
              .minute
              : 0,
          day: timeMonday.day,
          month: timeMonday.month,
          year: timeMonday.year,
          id: id,
          title: 'صيام الاثنين',
          body: 'صيام الاثنين',
          weekly: true,
          daily: false,
          i: i);
    }
    if(timeThursday!=null) {
      timeThursday=timeThursday.add(Duration(days: i*7));
      secheduledWeeklyNotification(
          hour: box.read('maghrib') != null
              ? parsPrayerTime(box.read('maghrib'))
              .add(Duration(hours: 1))
              .hour
              : 18,
          minutes: box.read('maghrib') != null
              ? parsPrayerTime(box.read('maghrib'))
              .add(Duration(hours: 1))
              .minute
              : 0,
          day: timeThursday.day,
          month: timeThursday.month,
          year: timeThursday.year,
          id: id + 1,
          title: 'صيام الخميس',
          body: 'صيام الخميس',
          weekly: true,
          daily: false,
          i: i);
    }
    emit(FastingMondayAndThursdayNotificationState());
  }
  lastHourFridayNotification({required int i, required int id}) {
    var friday = getNextFriday();

    var time = _nextInstanceOfFridayTenAM(friday,friday.month,friday.year, parsPrayerTime(box.read('maghrib')).subtract(Duration(hours: 1)).hour, parsPrayerTime(box.read('maghrib'))
        .subtract(Duration(hours: 1))
        .minute,)
    ;
    if(time!=null) {
      time=time.add(Duration(days: i * 7));
      secheduledWeeklyNotification(
          hour: time.hour ??
              6,
          minutes: time.minute ??
              10,
          day: time.day,
          month: time.month,
          year: time.year,
          id: id,
          title: 'وقال ربكم ادعوني استجب لكم',
          body: "آخر ساعة من يوم الجمعة وهي ساعة إجابة فاغتنمها",
          weekly: true,
          daily: false,
          i: i);
    }
    emit(LastHourFridayNotificationState());
  }

  duhaPrayerNotification({required day ,required int month,required int year, required id}) {
    if (box.read('dhuhr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 30))
            .hour,
        minutes: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 30))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id,
        title: 'صلاة الضحي',
        body: ' تذكير صلاة الضحي',
        weekly: false,
        daily: true,
      );
    }
    emit(MornPrayerNotificationState());
  }

  azkarNotifcation({required day ,required int month,required int year, required id}) {
    if (box.read('sunrise') != null) {
      scheduledNotification(
        hour:
        parsPrayerTime(box.read('sunrise')).add(Duration(minutes: 3)).hour,
        // 20
        minutes: parsPrayerTime(box.read('sunrise'))
            .add(Duration(minutes: 3))
            .minute,
        // 20
        day: day,
        month: month,
        year: year,
        id: id,
        title: 'أذكار الصباح',
        body: ' تذكير أذكار الصباح',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('asr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr')).add(Duration(minutes: 30)).hour,
        // 20
        minutes:
        parsPrayerTime(box.read('asr')).add(Duration(minutes: 30)).minute,
        // 20
        day: day,
        month: month,
        year: year,
        id: id + 1,
        title: 'أذكار المساء',
        body: ' تذكير أذكار المساء',
        weekly: false,
        daily: true,
      );
    }
    emit(AzkarNotificationState());
  }

  azanNotification({required day ,required int month,required int year, required id}) {
    if (box.read('fajr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('fajr')).hour,
        minutes: parsPrayerTime(box.read('fajr')).minute,
        day: day,
        month: month,
        year: year,
        id: id,
        title: 'صلاة الفجر',
        body: ' حان الأن موعد صلاة الفجر',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('dhuhr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('dhuhr')).hour,
        minutes: parsPrayerTime(box.read('dhuhr')).minute,
        day: day,
        month: month,
        year: year,
        id: id + 1,
        title: 'صلاة الظهر',
        body: ' حان الأن موعد صلاة الظهر',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('asr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr')).hour,
        minutes: parsPrayerTime(box.read('asr')).minute,
        day: day,
        month: month,
        year: year,
        id: id + 2,
        title: 'صلاة العصر',
        body: ' حان الأن موعد صلاة العصر',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('maghrib') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('maghrib')).hour,
        minutes: parsPrayerTime(box.read('maghrib')).minute,
        day: day,
        month: month,
        year: year,
        id: id + 3,
        title: 'صلاة المغرب',
        body: ' حان الأن موعد صلاة المغرب',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('isha') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('isha')).hour,
        minutes: parsPrayerTime(box.read('isha')).minute,
        day: day,
        month: month,
        year: year,
        id: id + 4,
        title: 'صلاة العشاء',
        body: ' حان الأن موعد صلاة العشاء',
        weekly: false,
        daily: true,
      );
    }
    if (box.read('sunrise') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('sunrise')).hour,
        minutes: parsPrayerTime(box.read('sunrise')).minute,
        day: day,
        month: month,
        year: year,
        id: id + 5,
        title: 'صلاة الشروق',
        body: 'حان الأن موعد صلاة الشروق',
        weekly: false,
        daily: true,
      );
    }

    emit(AzanNotificationState());
  }

  prayerTimeApproachingNotification({required day ,required int month,required int year, required id}) {
    if (box.read('fajr') != null &&
        box.read('dhuhr') != null &&
        box.read('asr') != null &&
        box.read('maghrib') != null &&
        box.read('isha') != null &&
        box.read('sunrise') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('fajr'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('fajr'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id,
        title: 'صلاة الفجر',
        body: ' اقتربت صلاة الفجر',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 1,
        title: 'صلاة الظهر',
        body: 'اقتربت صلاة الظهر',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('asr'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 2,
        title: 'صلاة العصر',
        body: ' اقتربت صلاة العصر',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('maghrib'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('maghrib'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 3,
        title: 'صلاة المغرب',
        body: ' اقتربت صلاة المغرب',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('isha'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('isha'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 4,
        title: 'صلاة العشاء',
        body: ' اقتربت صلاة العشاء',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('sunrise'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('sunrise'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 5,
        title: 'وقت الشروق',
        body: 'اقترب وقت الشروق',
        weekly: false,
        daily: true,
      );
    }
    emit(PrayerTimeApproachingNotificationState());
  }

  Eqama({required day ,required int month,required int year, required id}) {
    if (box.read('fajr') != null &&
        box.read('dhuhr') != null &&
        box.read('asr') != null &&
        box.read('maghrib') != null &&
        box.read('isha') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('fajr')).add(Duration(minutes: 3)).hour,
        minutes:
        parsPrayerTime(box.read('fajr')).add(Duration(minutes: 3)).minute,
        day: day,
        month: month,
        year: year,
        id: id,
        title: ' الدعاء بين الاذان والاقامة',
        body: '  دعاء',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('dhuhr')).add(Duration(minutes: 3)).hour,
        minutes:
        parsPrayerTime(box.read('dhuhr')).add(Duration(minutes: 3)).minute,
        day: day,
        month: month,
        year: year,
        id: id + 1,
        title: ' الدعاء بين الاذان والاقامة',
        body: '  دعاء',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr')).add(Duration(minutes: 3)).hour,
        minutes:
        parsPrayerTime(box.read('asr')).add(Duration(minutes: 3)).minute,
        day: day,
        month: month,
        year: year,
        id: id + 2,
        title: ' الدعاء بين الاذان والاقامة',
        body: '  دعاء',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour:
        parsPrayerTime(box.read('maghrib')).add(Duration(minutes: 3)).hour,
        minutes: parsPrayerTime(box.read('maghrib'))
            .add(Duration(minutes: 3))
            .minute,
        day: day,
        month: month,
        year: year,
        id: id + 3,
        title: ' الدعاء بين الاذان والاقامة',
        body: '  دعاء',
        weekly: false,
        daily: true,
      );
      scheduledNotification(
        hour: parsPrayerTime(box.read('isha')).add(Duration(minutes: 3)).hour,
        minutes:
        parsPrayerTime(box.read('isha')).add(Duration(minutes: 3)).minute,
        day: day,
        month: month,
        year: year,
        id: id + 4,
        title: ' الدعاء بين الاذان والاقامة',
        body: '  دعاء',
        weekly: false,
        daily: true,
      );
    }

    emit(SetEqamaState());
  }

  cancelSurahElKahfNotification({required int id}) {
    cancel(id);
    emit(CancelSurahElKahfNotificationState());
  }

  cancelEarlyJoumaHourNotification({required int id}) {
    cancel(id);
    cancel(id + 1);
    cancel(id + 2);
    cancel(id + 3);
    cancel(id + 4);
    emit(CancelEarlyJoumaHourNotificationState());
  }

  cancelNightPrayerNotification({required id}) {
    cancel(id);

    emit(CancelNightPrayerNotificationState());
  }

  cancelMondayThursdayNotification({required int id}) {
    cancel(id);
    cancel(id + 1);
    emit(CancelFastingMondayAndThursdayNotificationState());
  }

  cancelDuhaPrayerNotification({required id}) {
    cancel(id);
    emit(CancelMornPrayerNotificationState());
  }

  cancelAzkarNotifcation({required id}) {
    cancel(id);
    cancel(id + 1);
    emit(CancelAzkarNotificationState());
  }


  cancelPrayerTimeApproachingNotification({required id}) {
    cancel(id);
    cancel(id + 1);
    cancel(id + 2);
    cancel(id + 3);
    cancel(id + 4);
    cancel(id + 5);
    emit(CancelPrayerTimeApproachingNotificationState());
  }



  cancelLastHourFridayNotification({required int id}) {
    cancel(id);
    emit(CancelLastHourFridayNotificationState());
  }

  prayOnProphetNotification({required day ,required int month,required int year, required id}) {
    scheduledNotification(
      hour: box.read('fajr') == null
          ? 5
          : parsPrayerTime(box.read('fajr')).add(Duration(minutes: 10)).hour,
      minutes: box.read('fajr') == null
          ? 0
          : parsPrayerTime(box.read('fajr')).add(Duration(minutes: 10)).minute,
      day: day,
      month: month,
      year: year,
      id: id,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: true,
      daily: false,
    );
    scheduledNotification(
      hour: box.read('dhuhr') == null
          ? 12
          : parsPrayerTime(box.read('dhuhr')).add(Duration(minutes: 10)).hour,
      minutes: box.read('dhuhr') == null
          ? 0
          : parsPrayerTime(box.read('dhuhr')).add(Duration(minutes: 10)).minute,
      day: day,
      month: month,
      year: year,
      id: id + 1,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: box.read('asr') == null
          ? 15
          : parsPrayerTime(box.read('asr')).add(Duration(minutes: 10)).hour,
      minutes: box.read('asr') == null
          ? 0
          : parsPrayerTime(box.read('asr')).add(Duration(minutes: 10)).minute,
      day: day,
      month: month,
      year: year,
      id: id + 2,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: true,
      daily: false,
    );
    scheduledNotification(
      hour: box.read('magrib') == null
          ? 18
          : parsPrayerTime(box.read('maghrib')).add(Duration(minutes: 10)).hour,
      minutes: box.read('maghrib') == null
          ? 0
          : parsPrayerTime(box.read('maghrib'))
          .add(Duration(minutes: 10))
          .minute,
      day: day,
      month: month,
      year: year,
      id: id + 3,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: box.read('isha') == null
          ? 20
          : parsPrayerTime(box.read('isha')).add(Duration(minutes: 10)).hour,
      minutes: box.read('isha') == null
          ? 0
          : parsPrayerTime(box.read('isha')).add(Duration(minutes: 10)).minute,
      day: day,
      month: month,
      year: year,
      id: id + 4,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: false,
      daily: true,
    );

    emit(PrayOnProphetNotificationState());
  }

  cancelPrayOnProphetNotification({id}) {
    cancel(id);
    cancel(id + 1);
    cancel(id + 2);
    cancel(id + 3);
    cancel(id + 4);

    emit(CancelPrayOnProphetNotificationState());
  }

  dailyQuranNotification({required day ,required int month,required int year, required id}) {
    if (box.read('asr') != null) {
      scheduledNotificationV2(
        hour: parsPrayerTime(box.read('asr')).add(Duration(minutes: 35)).hour ??
            15,
        minutes:
        parsPrayerTime(box.read('asr')).add(Duration(minutes: 35)).minute ??
            30,
        day: day,
        month: month,
        year: year,
        id: id,
        title: 'القرآن الكريم',
        body: "قراءة الورد اليومي",
        weekly: false,
        daily: true,
      );
    }
    emit(DailyQuranNotificationState());
  }

  cancelDailyQuranNotification({required id}) {
    cancel(id);
    emit(CancelDailyQuranNotificationState());
  }

  turnOnAllNotification()async {
    var surahElkahfNotificationValue = CacheHelper.getData(key: surahElKahfKey)??true;
    var joumaaHoursNotificationValue = CacheHelper.getData(key: joumaaHoursKey)??true;
    var doaaLastHourNotificationValue =
        CacheHelper.getData(key: doaaLastHourKey)??true;
    var prayOnProphetNotificationValue =
        CacheHelper.getData(key: prayOnProphetKey)??true;
    var duhaPrayerNotificationValue = CacheHelper.getData(key: duhaPrayerKey)??true;
    var mondayThursdayNotificationValue =
        CacheHelper.getData(key: mondayThursdayKey)??true;
    var eqamaNotificationValue = CacheHelper.getData(key: eqamaKey)??true;
    var nightPrayerNotificationValue = CacheHelper.getData(key: nightPrayerKey)??true;
    var dailyQuranNotificationValue = CacheHelper.getData(key: dailyQuranKey)??true;
    var morningEveningNotificationValue =
        CacheHelper.getData(key: morningEveningKey)??true;
    var approachingPrayersNotificationValue =
        CacheHelper.getData(key: approachingPrayersKey)??true;
    setSurahElkahfNotification(surahElkahfNotificationValue);
    setJumaaHoursNotification(joumaaHoursNotificationValue);

    setMondayThursdayNotification(mondayThursdayNotificationValue);

    setNightPrayerNotification(nightPrayerNotificationValue);

    setDuhaPrayerNotification(duhaPrayerNotificationValue);

    setMorningEveningNotification(morningEveningNotificationValue);

    setAzanNotification();

    setapproachingPrayersNotification(approachingPrayersNotificationValue);

    setDoaaLastJoumaaHourNotification(doaaLastHourNotificationValue);

    setPrayOnProphetNotification(prayOnProphetNotificationValue);

    setEqamNotification(eqamaNotificationValue);

    setDailyQuran(dailyQuranNotificationValue);

    emit(TurnOnAllNotificationState());
  }

  setAzanNotification() {
    azanNotification(day: DateTime.now().add(Duration(days: 0)).day,month:DateTime.now().add(Duration(days: 0)).month ,year: DateTime.now().add(Duration(days: 0)).year ,id: 300);
    azanNotification(day: DateTime.now().add(Duration(days: 1)).day,month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year ,id: 306);
    azanNotification(day: DateTime.now().add(Duration(days: 2)).day,month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year ,id: 312);
    azanNotification(day: DateTime.now().add(Duration(days: 3)).day,month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year ,id: 318);
    azanNotification(day: DateTime.now().add(Duration(days: 4)).day,month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year ,id: 324);
    azanNotification(day: DateTime.now().add(Duration(days: 5)).day,month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year ,id: 330);
    azanNotification(day: DateTime.now().add(Duration(days: 6)).day,month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year ,id: 336);
    azanNotification(day: DateTime.now().add(Duration(days: 7)).day,month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year ,id: 342);
    azanNotification(day: DateTime.now().add(Duration(days: 8)).day,month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year ,id: 348);
    azanNotification(day: DateTime.now().add(Duration(days: 9)).day,month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year ,id: 354);
    azanNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month ,year: DateTime.now().add(Duration(days: 10)).year,id: 360);
    azanNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month ,year: DateTime.now().add(Duration(days: 11)).year,id: 366);
    azanNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month ,year: DateTime.now().add(Duration(days: 12)).year,id: 372);
    azanNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month ,year: DateTime.now().add(Duration(days: 13)).year,id: 378);
    azanNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month ,year: DateTime.now().add(Duration(days: 14)).year,id: 384);
    azanNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month ,year: DateTime.now().add(Duration(days: 15)).year,id: 390);
    // azanNotification(day: DateTime.now().add(Duration(days: 16)).day, id: 396);
    // azanNotification(day: DateTime.now().add(Duration(days: 17)).day, id: 402);
    // azanNotification(day: DateTime.now().add(Duration(days: 18)).day, id: 408);
    // azanNotification(day: DateTime.now().add(Duration(days: 19)).day, id: 414);
    // azanNotification(day: DateTime.now().add(Duration(days: 20)).day, id: 420);

    emit(SetAzanNotificationState());
  }

  setDailyQuran(dailyQuranNotificationValue) {
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,  id: 800) : cancelDailyQuranNotification(id: 800);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year, id: 801) : cancelDailyQuranNotification(id: 801);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year, id: 802) : cancelDailyQuranNotification(id: 802);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year, id: 803) : cancelDailyQuranNotification(id: 803);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year, id: 804) : cancelDailyQuranNotification(id: 804);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year, id: 805) : cancelDailyQuranNotification(id: 805);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year, id: 806) : cancelDailyQuranNotification(id: 806);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year, id: 807) : cancelDailyQuranNotification(id: 807);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year, id: 808) : cancelDailyQuranNotification(id: 808);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year, id: 809) : cancelDailyQuranNotification(id: 809);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year, id: 810) : cancelDailyQuranNotification(id: 810);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year, id: 811) : cancelDailyQuranNotification(id: 811);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year, id: 812) : cancelDailyQuranNotification(id: 812);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year, id: 813) : cancelDailyQuranNotification(id: 813);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year, id: 814) : cancelDailyQuranNotification(id: 814);
    dailyQuranNotificationValue ?? true ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year, id: 815) : cancelDailyQuranNotification(id: 815);
    // dailyQuranNotificationValue ?? trueday: DateTime.now().add(Duration(days: 0)).day,day: DateTime.now().add(Duration(days: 0)).day,
    //     ? dailyQuranNotification(day: DateTime.now().add(Duration(days: 0)).day,day: DateTime.now().add(Duration(days: 0)).day,
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 816)
    //     : cancelDailyQuranNotification(id: 816);
    // dailyQuranNotificationValue ?? true
    //     ? dailyQuranNotification(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 817)
    //     : cancelDailyQuranNotification(id: 817);
    // dailyQuranNotificationValue ?? true
    //     ? dailyQuranNotification(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 818)
    //     : cancelDailyQuranNotification(id: 818);
    // dailyQuranNotificationValue ?? true
    //     ? dailyQuranNotification(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 819)
    //     : cancelDailyQuranNotification(id: 819);
    // dailyQuranNotificationValue ?? true
    //     ? dailyQuranNotification(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 820)
    //     : cancelDailyQuranNotification(id: 820);

    emit(SetDailyQuranNotificationState());
  }

  setEqamNotification(eqamaNotificationValue) {
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,    id: 600) : cancelEqama(id: 600);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,    id: 606) : cancelEqama(id: 606);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,    id: 612) : cancelEqama(id: 612);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,    id: 618) : cancelEqama(id: 618);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,    id: 624) : cancelEqama(id: 624);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,    id: 630) : cancelEqama(id: 630);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,    id: 636) : cancelEqama(id: 636);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,    id: 642) : cancelEqama(id: 642);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,    id: 648) : cancelEqama(id: 648);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,    id: 654) : cancelEqama(id: 654);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 660) : cancelEqama(id: 660);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 666) : cancelEqama(id: 666);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 672) : cancelEqama(id: 672);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 678) : cancelEqama(id: 678);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 684) : cancelEqama(id: 684);
    eqamaNotificationValue ?? true ? Eqama(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 690) : cancelEqama(id: 690);
    // eqamaNotificationValue ?? true
    //     ? Eqama(day: DateTime.now().add(Duration(days: 16)).day, id: 696)
    //     : cancelEqama(id: 696);
    // eqamaNotificationValue ?? true
    //     ? Eqama(day: DateTime.now().add(Duration(days: 17)).day, id: 702)
    //     : cancelEqama(id: 702);
    // eqamaNotificationValue ?? true
    //     ? Eqama(day: DateTime.now().add(Duration(days: 18)).day, id: 708)
    //     : cancelEqama(id: 708);
    // eqamaNotificationValue ?? true
    //     ? Eqama(day: DateTime.now().add(Duration(days: 19)).day, id: 714)
    //     : cancelEqama(id: 714);
    // eqamaNotificationValue ?? true
    //     ? Eqama(day: DateTime.now().add(Duration(days: 20)).day, id: 720)
    //     : cancelEqama(id: 720);

    emit(SetEqamaNotificationState());
  }

  setPrayOnProphetNotification(prayOnProphetNotificationValue) {
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,   id: 850) : cancelPrayOnProphetNotification(id: 850);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,   id: 856) : cancelPrayOnProphetNotification(id: 856);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,   id: 861) : cancelPrayOnProphetNotification(id: 861);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,   id: 866) : cancelPrayOnProphetNotification(id: 866);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,   id: 871) : cancelPrayOnProphetNotification(id: 871);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,   id: 876) : cancelPrayOnProphetNotification(id: 876);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,   id: 881) : cancelPrayOnProphetNotification(id: 881);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,   id: 886) : cancelPrayOnProphetNotification(id: 886);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,   id: 891) : cancelPrayOnProphetNotification(id: 891);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,   id: 896) : cancelPrayOnProphetNotification(id: 896);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 901) : cancelPrayOnProphetNotification(id: 901);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 906) : cancelPrayOnProphetNotification(id: 906);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 911) : cancelPrayOnProphetNotification(id: 911);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 916) : cancelPrayOnProphetNotification(id: 916);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 921) : cancelPrayOnProphetNotification(id: 921);
    prayOnProphetNotificationValue ?? true ? prayOnProphetNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 926) : cancelPrayOnProphetNotification(id: 926);
    // prayOnProphetNotificationValue ?? true
    //     ? prayOnProphetNotification(
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 931)
    //     : cancelPrayOnProphetNotification(id: 931);
    // prayOnProphetNotificationValue ?? true
    //     ? prayOnProphetNotification(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 936)
    //     : cancelPrayOnProphetNotification(id: 936);
    // prayOnProphetNotificationValue ?? true
    //     ? prayOnProphetNotification(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 941)
    //     : cancelPrayOnProphetNotification(id: 941);
    // prayOnProphetNotificationValue ?? true
    //     ? prayOnProphetNotification(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 946)
    //     : cancelPrayOnProphetNotification(id: 946);
    // prayOnProphetNotificationValue ?? true
    //     ? prayOnProphetNotification(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 951)
    //     : cancelPrayOnProphetNotification(id: 951);

    emit(SetPrayOnProphetNotificationState());
  }

  setapproachingPrayersNotification(approachingPrayersNotificationValue) {
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,   id: 430) : cancelPrayerTimeApproachingNotification(id: 430);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,   id: 436) : cancelPrayerTimeApproachingNotification(id: 436);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,   id: 442) : cancelPrayerTimeApproachingNotification(id: 442);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,   id: 448) : cancelPrayerTimeApproachingNotification(id: 448);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,   id: 454) : cancelPrayerTimeApproachingNotification(id: 454);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,   id: 460) : cancelPrayerTimeApproachingNotification(id: 460);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,   id: 466) : cancelPrayerTimeApproachingNotification(id: 466);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,   id: 472) : cancelPrayerTimeApproachingNotification(id: 472);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,   id: 478) : cancelPrayerTimeApproachingNotification(id: 478);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,   id: 484) : cancelPrayerTimeApproachingNotification(id: 484);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 490) : cancelPrayerTimeApproachingNotification(id: 490);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 496) : cancelPrayerTimeApproachingNotification(id: 496);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 502) : cancelPrayerTimeApproachingNotification(id: 502);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 508) : cancelPrayerTimeApproachingNotification(id: 508);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 514) : cancelPrayerTimeApproachingNotification(id: 514);
    approachingPrayersNotificationValue ?? true ? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 520) : cancelPrayerTimeApproachingNotification(id: 520);
    // approachingPrayersNotificationValue ?? true
    //     ? prayerTimeApproachingNotification(
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 526)
    //     : cancelPrayerTimeApproachingNotification(id: 526);
    // approachingPrayersNotificationValue ?? true
    //     ? prayerTimeApproachingNotification(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 532)
    //     : cancelPrayerTimeApproachingNotification(id: 532);
    // approachingPrayersNotificationValue ?? true
    //     ? prayerTimeApproachingNotification(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 538)
    //     : cancelPrayerTimeApproachingNotification(id: 538);
    // approachingPrayersNotificationValue ?? true
    //     ? prayerTimeApproachingNotification(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 544)
    //     : cancelPrayerTimeApproachingNotification(id: 544);
    // approachingPrayersNotificationValue ?? true
    //     ? prayerTimeApproachingNotification(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 550)
    //     : cancelPrayerTimeApproachingNotification(id: 550);

    emit(SetApproachingPrayersNotificationState());
  }

  setMorningEveningNotification(morningEveningNotificationValue) {
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,   id: 143) : cancelAzkarNotifcation(id: 143);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,   id: 145) : cancelAzkarNotifcation(id: 145);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,   id: 147) : cancelAzkarNotifcation(id: 147);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,   id: 149) : cancelAzkarNotifcation(id: 149);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,   id: 151) : cancelAzkarNotifcation(id: 151);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,   id: 153) : cancelAzkarNotifcation(id: 153);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,   id: 155) : cancelAzkarNotifcation(id: 155);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,   id: 157) : cancelAzkarNotifcation(id: 157);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,   id: 159) : cancelAzkarNotifcation(id: 159);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,   id: 161) : cancelAzkarNotifcation(id: 161);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 163) : cancelAzkarNotifcation(id: 163);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 165) : cancelAzkarNotifcation(id: 165);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 167) : cancelAzkarNotifcation(id: 167);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 169) : cancelAzkarNotifcation(id: 169);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 171) : cancelAzkarNotifcation(id: 171);
    morningEveningNotificationValue ?? true ? azkarNotifcation(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 173) : cancelAzkarNotifcation(id: 173);
    // morningEveningNotificationValue ?? true
    //     ? azkarNotifcation(
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 175)
    //     : cancelAzkarNotifcation(id: 175);
    // morningEveningNotificationValue ?? true
    //     ? azkarNotifcation(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 177)
    //     : cancelAzkarNotifcation(id: 177);
    // morningEveningNotificationValue ?? true
    //     ? azkarNotifcation(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 179)
    //     : cancelAzkarNotifcation(id: 179);
    // morningEveningNotificationValue ?? true
    //     ? azkarNotifcation(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 181)
    //     : cancelAzkarNotifcation(id: 181);
    // morningEveningNotificationValue ?? true
    //     ? azkarNotifcation(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 183)
    //     : cancelAzkarNotifcation(id: 183);

    emit(SetMorningEveningNotificationState());
  }

  setDuhaPrayerNotification(duhaPrayerNotificationValue) {
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,   id: 121) : cancelDuhaPrayerNotification(id: 121);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,   id: 122) : cancelDuhaPrayerNotification(id: 122);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,   id: 123) : cancelDuhaPrayerNotification(id: 123);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,   id: 124) : cancelDuhaPrayerNotification(id: 124);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,   id: 125) : cancelDuhaPrayerNotification(id: 125);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,   id: 126) : cancelDuhaPrayerNotification(id: 126);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,   id: 127) : cancelDuhaPrayerNotification(id: 127);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,   id: 128) : cancelDuhaPrayerNotification(id: 128);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,   id: 129) : cancelDuhaPrayerNotification(id: 129);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,   id: 130) : cancelDuhaPrayerNotification(id: 130);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 131) : cancelDuhaPrayerNotification(id: 131);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 132) : cancelDuhaPrayerNotification(id: 132);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 134) : cancelDuhaPrayerNotification(id: 134);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 135) : cancelDuhaPrayerNotification(id: 135);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 136) : cancelDuhaPrayerNotification(id: 136);
    duhaPrayerNotificationValue ?? true ? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 137)
        : cancelDuhaPrayerNotification(id: 137);
    // duhaPrayerNotificationValue ?? true
    //     ? duhaPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 138)
    //     : cancelDuhaPrayerNotification(id: 138);
    // duhaPrayerNotificationValue ?? true
    //     ? duhaPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 139)
    //     : cancelDuhaPrayerNotification(id: 139);
    // duhaPrayerNotificationValue ?? true
    //     ? duhaPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 140)
    //     : cancelDuhaPrayerNotification(id: 140);
    // duhaPrayerNotificationValue ?? true
    //     ? duhaPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 141)
    //     : cancelDuhaPrayerNotification(id: 141);
    // duhaPrayerNotificationValue ?? true
    //     ? duhaPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 142)
    //     : cancelDuhaPrayerNotification(id: 142);

    emit(SetDuhaPrayerNotificationState());
  }

  setNightPrayerNotification(nightPrayerNotificationValue) {
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 0)).day, month: DateTime.now().add(Duration(days: 0)).month,year: DateTime.now().add(Duration(days: 0)).year,   id: 100) : cancelNightPrayerNotification(id: 100);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 1)).day, month: DateTime.now().add(Duration(days: 1)).month,year: DateTime.now().add(Duration(days: 1)).year,   id: 101) : cancelNightPrayerNotification(id: 101);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 2)).day, month: DateTime.now().add(Duration(days: 2)).month,year: DateTime.now().add(Duration(days: 2)).year,   id: 102) : cancelNightPrayerNotification(id: 102);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 3)).day, month: DateTime.now().add(Duration(days: 3)).month,year: DateTime.now().add(Duration(days: 3)).year,   id: 103) : cancelNightPrayerNotification(id: 103);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 4)).day, month: DateTime.now().add(Duration(days: 4)).month,year: DateTime.now().add(Duration(days: 4)).year,   id: 104) : cancelNightPrayerNotification(id: 104);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 5)).day, month: DateTime.now().add(Duration(days: 5)).month,year: DateTime.now().add(Duration(days: 5)).year,   id: 105) : cancelNightPrayerNotification(id: 105);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 6)).day, month: DateTime.now().add(Duration(days: 6)).month,year: DateTime.now().add(Duration(days: 6)).year,   id: 106) : cancelNightPrayerNotification(id: 106);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 7)).day, month: DateTime.now().add(Duration(days: 7)).month,year: DateTime.now().add(Duration(days: 7)).year,   id: 107) : cancelNightPrayerNotification(id: 107);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 8)).day, month: DateTime.now().add(Duration(days: 8)).month,year: DateTime.now().add(Duration(days: 8)).year,   id: 108) : cancelNightPrayerNotification(id: 108);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 9)).day, month: DateTime.now().add(Duration(days: 9)).month,year: DateTime.now().add(Duration(days: 9)).year,   id: 109) : cancelNightPrayerNotification(id: 109);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 10)).day,month: DateTime.now().add(Duration(days: 10)).month,year: DateTime.now().add(Duration(days: 10)).year,  id: 110) : cancelNightPrayerNotification(id: 110);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 11)).day,month: DateTime.now().add(Duration(days: 11)).month,year: DateTime.now().add(Duration(days: 11)).year,  id: 111) : cancelNightPrayerNotification(id: 111);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 12)).day,month: DateTime.now().add(Duration(days: 12)).month,year: DateTime.now().add(Duration(days: 12)).year,  id: 112) : cancelNightPrayerNotification(id: 112);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 13)).day,month: DateTime.now().add(Duration(days: 13)).month,year: DateTime.now().add(Duration(days: 13)).year,  id: 113) : cancelNightPrayerNotification(id: 113);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 14)).day,month: DateTime.now().add(Duration(days: 14)).month,year: DateTime.now().add(Duration(days: 14)).year,  id: 114) : cancelNightPrayerNotification(id: 114);
    nightPrayerNotificationValue ?? true ? nightPrayerNotification(day: DateTime.now().add(Duration(days: 15)).day,month: DateTime.now().add(Duration(days: 15)).month,year: DateTime.now().add(Duration(days: 15)).year,  id: 115) : cancelNightPrayerNotification(id: 115);
    // nightPrayerNotificationValue ?? true
    //     ? nightPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 16)).day, id: 116)
    //     : cancelNightPrayerNotification(id: 116);
    // nightPrayerNotificationValue ?? true
    //     ? nightPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 17)).day, id: 117)
    //     : cancelNightPrayerNotification(id: 117);
    // nightPrayerNotificationValue ?? true
    //     ? nightPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 18)).day, id: 118)
    //     : cancelNightPrayerNotification(id: 118);
    // nightPrayerNotificationValue ?? true
    //     ? nightPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 19)).day, id: 119)
    //     : cancelNightPrayerNotification(id: 119);
    // nightPrayerNotificationValue ?? true
    //     ? nightPrayerNotification(
    //         day: DateTime.now().add(Duration(days: 20)).day, id: 120)
    //     : cancelNightPrayerNotification(id: 120);

    emit(SetNightPrayerNotificationState());
  }

  setJumaaHoursNotification(joumaaHoursNotificationValue) {
    if (joumaaHoursNotificationValue) {
      earlyJoumaHourNotification(i: 0, id: 1100);
      // earlyJoumaHourNotification(i: 1, id: 1106);
      // earlyJoumaHourNotification(i: 2, id: 1112);
      // earlyJoumaHourNotification(i: 3, id: 1118);
      // earlyJoumaHourNotification(i: 4, id: 1124);
      // earlyJoumaHourNotification(i: 5, id: 1130);
      // earlyJoumaHourNotification(i: 6, id: 1136);
      // earlyJoumaHourNotification(i: 7, id: 1142);
      // earlyJoumaHourNotification(i: 8, id: 1148);
      // earlyJoumaHourNotification(i: 9, id: 1154);
      // earlyJoumaHourNotification(i: 10, id: 1160);
    } else {
      cancelEarlyJoumaHourNotification(id: 1100);
      // cancelEarlyJoumaHourNotification(id: 1106);
      // cancelEarlyJoumaHourNotification(id: 1112);
      // cancelEarlyJoumaHourNotification(id: 1118);
      // cancelEarlyJoumaHourNotification(id: 1124);
      // cancelEarlyJoumaHourNotification(id: 1130);
      // cancelEarlyJoumaHourNotification(id: 1136);
      // cancelEarlyJoumaHourNotification(id: 1142);
      // cancelEarlyJoumaHourNotification(id: 1148);
      // cancelEarlyJoumaHourNotification(id: 1154);
      // cancelEarlyJoumaHourNotification(id: 1160);
    }

    emit(SetJoumaaHourNotificationState());
  }

  setSurahElkahfNotification(surahElkahfNotificationValue) {
    if (surahElkahfNotificationValue) {
      surahElKahfNotification(i: 0, id: 1300);
      // surahElKahfNotification(i: 1, id: 1301);
      // surahElKahfNotification(i: 2, id: 1302);
      // surahElKahfNotification(i: 3, id: 1303);
      // surahElKahfNotification(i: 4, id: 1304);
      // surahElKahfNotification(i: 5, id: 1305);
      // surahElKahfNotification(i: 6, id: 1306);
      // surahElKahfNotification(i: 7, id: 1307);
      // surahElKahfNotification(i: 8, id: 1308);
      // surahElKahfNotification(i: 9, id: 1309);
      // surahElKahfNotification(i: 10, id: 1310);
    } else {
      cancelSurahElKahfNotification(id: 1300);
      // cancelSurahElKahfNotification(id: 1301);
      // cancelSurahElKahfNotification(id: 1302);
      // cancelSurahElKahfNotification(id: 1303);
      // cancelSurahElKahfNotification(id: 1304);
      // cancelSurahElKahfNotification(id: 1305);
      // cancelSurahElKahfNotification(id: 1306);
      // cancelSurahElKahfNotification(id: 1307);
      // cancelSurahElKahfNotification(id: 1308);
      // cancelSurahElKahfNotification(id: 1309);
      // cancelSurahElKahfNotification(id: 1310);
    }

    emit(SetSurahElkahfNotificationState());
  }

  setMondayThursdayNotification(mondayThursdayNotificationValue) {
    if (mondayThursdayNotificationValue) {
      mondayThursdayNotification(i: 0, id: 1500);
      // mondayThursdayNotification(i: 1, id: 1503);
      // mondayThursdayNotification(i: 2, id: 1506);
      // mondayThursdayNotification(i: 3, id: 1509);
      // mondayThursdayNotification(i: 4, id: 1512);
      // mondayThursdayNotification(i: 5, id: 1515);
      // mondayThursdayNotification(i: 6, id: 1518);
      // mondayThursdayNotification(i: 7, id: 1521);
      // mondayThursdayNotification(i: 8, id: 1524);
      // mondayThursdayNotification(i: 9, id: 1527);
      // mondayThursdayNotification(i: 10, id: 1530);
    } else {
      cancelMondayThursdayNotification(id: 1500);
      // cancelMondayThursdayNotification(id: 1503);
      // cancelMondayThursdayNotification(id: 1506);
      // cancelMondayThursdayNotification(id: 1509);
      // cancelMondayThursdayNotification(id: 1512);
      // cancelMondayThursdayNotification(id: 1515);
      // cancelMondayThursdayNotification(id: 1518);
      // cancelMondayThursdayNotification(id: 1521);
      // cancelMondayThursdayNotification(id: 1524);
      // cancelMondayThursdayNotification(id: 1527);
      // cancelMondayThursdayNotification(id: 1530);
    }
    emit(SetMondayThursdayNotificationState());
  }

  setDoaaLastJoumaaHourNotification(doaaLastHourNotificationValue) {
    if (doaaLastHourNotificationValue) {
      lastHourFridayNotification(i: 0, id: 1700);
      // lastHourFridayNotification(i: 1, id: 1701);
      // lastHourFridayNotification(i: 2, id: 1702);
      // lastHourFridayNotification(i: 3, id: 1703);
      // lastHourFridayNotification(i: 4, id: 1704);
      // lastHourFridayNotification(i: 5, id: 1705);
      // lastHourFridayNotification(i: 6, id: 1706);
      // lastHourFridayNotification(i: 7, id: 1707);
      // lastHourFridayNotification(i: 8, id: 1708);
      // lastHourFridayNotification(i: 9, id: 1709);
      // lastHourFridayNotification(i: 10, id: 1710);
    } else {
      cancelLastHourFridayNotification(id: 1700);
      // cancelLastHourFridayNotification(id: 1701);
      // cancelLastHourFridayNotification(id: 1702);
      // cancelLastHourFridayNotification(id: 1703);
      // cancelLastHourFridayNotification(id: 1704);
      // cancelLastHourFridayNotification(id: 1705);
      // cancelLastHourFridayNotification(id: 1706);
      // cancelLastHourFridayNotification(id: 1707);
      // cancelLastHourFridayNotification(id: 1708);
      // cancelLastHourFridayNotification(id: 1709);
      // cancelLastHourFridayNotification(id: 1710);
    }
    emit(SetDoaaLastJoumaaHourNotificationState());
  }

//--------------------------------------

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var message;
  getAdminMassagesFromFirebase({
    required String collectionName,
    required String docName,
  }) async {
    await firestore.collection(collectionName).doc(docName).get().then((value) {
      if (value.data() != null) {
        message = value.data()!['text'];

        box.write(collectionName, message);
        collectionName == adminMessageCollectionAr
            ? box.write(newAdminMessageAr, value.data()!['text'])
            : collectionName == adminMessageCollectionEn
            ? box.write(newAdminMessageEn, value.data()!['text'])
            : null;
      } else {
        debugPrint(collectionName + ' is null');
      }

      emit(GetAdminMassageEnFromFirebaseState());
    });
  }

  var imageEn;
  getImageEnFromFirebaseStorage() async {
    FirebaseFirestore.instance
        .collection('ads_En')
        .doc('ads_En')
        .get()
        .then((value) {
      if (value.data() != null) {
        // imageEn = value.data()!['imageEn'];

        box.write('imageEn', value.data()!['imageEn']);
        emit(GetImageFromFirebaseStorageEnState());
      } else {
        FirebaseStorage.instance
            .ref()
            .child('imageEn')
            .getDownloadURL()
            .then((value) {
          box.write('imageEn', value);
          emit(GetImageFromFirebaseStorageEnState());
        });
      }
    });
  }

  getImageArFromFirebase() async {
    FirebaseFirestore.instance
        .collection('ads_Ar')
        .doc('ads_Ar')
        .get()
        .then((value) {
      if (value.data()!['imageAr'] != null) {
        box.write('imageAr', value.data()!['imageAr'] ?? logoUrl);
        emit(GetImageFromFirebaseStorageState());
      } else {
        FirebaseStorage.instance
            .ref()
            .child('imageAr')
            .getDownloadURL()
            .then((value) {
          box.write('imageAr', value ?? logoUrl);
          emit(GetImageFromFirebaseStorageState());
        });
      }
    });
  }
  parsTime(String time) {
    var timeParse = DateTime.parse(time);
    debugPrint('timeParse is $timeParse');
    var timeFormat = timeParse.isAfter(DateTime.now());
    return timeFormat;
  }

  deletePost(
      {

        required String id,
        required String CollectionName,
      }
      )async{

    FirebaseFirestore.instance.collection(CollectionName).doc(id).delete().then((value) => {
      // CacheHelper.saveData(key: 'image$label', value: value),
      debugPrint('delete Success'),
      // showToast(text: 'post deleted', state: ToastStates.ERROR, seconds: 2),
      // getPosts(collectionName: CollectionName)

    }).catchError((error) {
      debugPrint('the error is ====>'+error.toString());
    });



  }

  Future getPosts({
    required String collectionName,
  }) async {
    var box = GetStorage();

    List Links = [];
    List imageId = [];
    FirebaseFirestore.instance.collection(collectionName).get().then((value) {
      Links = [];
      imageId = [];
      debugPrint('value is this ==> ' + value.docs.toString());
      value.docs.forEach((element) {

        if(collectionName==adsCollectionNameAr||collectionName==adsCollectionNameEN) {
          if(element.data()['status']==true) {
            if (element.data()['updated_at'] != null) {
              if (parsTime(element.data()['updated_at']) == false) {
                deletePost(
                    id: element.data()['id'], CollectionName: collectionName);
              }
            }
          }
        }
        Links.add(element.data()['link']);

        imageId.add(element.data()['id']);






      });
      collectionName == adsCollectionNameAr
          ? box.write(keyLinksAr, Links)
          : box.write(keyLinksEn, Links);

      collectionName == adsCollectionNameAr
          ? box.write(keyImageIdAr, imageId)
          : box.write(keyImageIdEn, imageId);
      debugPrint('links is ====>'+Links.toString());
      debugPrint('imageId========>'+imageId.toString());
      emit(GetImageFromFirebaseStorageState());
    }).catchError((error) {
      debugPrint('error is this ==> ' + error.toString());
      emit(GetImageFromFirebaseStorageErrorState());
    });
  }

  getAllFromFirebase() async {
    await getPosts(collectionName: adsCollectionNameAr);
    await getPosts(collectionName: adsCollectionNameEN);
    await getAdminMassagesFromFirebase(
        collectionName: adminMessageCollectionAr, docName: adminMessageDocAr);
    await getAdminMassagesFromFirebase(
        collectionName: adminMessageCollectionEn, docName: adminMessageDocEn);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaHadithCollectionAr, docName: jumaaHadithDocAr);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaHadithCollectionEn, docName: jumaaHadithDocEn);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionAr1, docName: jumaaSuinnDocAr1);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionAr2, docName: jumaaSuinnDocAr2);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionAr3, docName: jumaaSuinnDocAr3);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionEn1, docName: jumaaSuinnDocEn1);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionEn2, docName: jumaaSuinnDocEn2);
    await getAdminMassagesFromFirebase(
        collectionName: jumaaSuinnCollectiionEn3, docName: jumaaSuinnDocEn3);
    await getAdminMassagesFromFirebase(
        collectionName: nightHadithCollectionAr, docName: nightHadithDocAr);
    await getAdminMassagesFromFirebase(
        collectionName: nightHadithCollectionEn, docName: nightHadithDocEn);
    await getAdminMassagesFromFirebase(
        collectionName: forWhoCollectionNameAr, docName: forWhoDocNameAr);
    await getAdminMassagesFromFirebase(
        collectionName: forWhoCollectionNameEn, docName: forWhoDocNameEn);
    await getAdminMassagesFromFirebase(
        collectionName: privacyCollectionNameAr, docName: privacyDocNameAr);
    await getAdminMassagesFromFirebase(
        collectionName: privacyCollectionNameEn, docName: privacyDocNameEn);
    await getAdminMassagesFromFirebase(
        collectionName: contactUsCollectionName, docName: contactUsDocName);
    emit(GetAllFromFirebaseState());
  }

  initApp(context) async {
    await InternetConnectionChecker().hasConnection.then((result) async {
      if (result == true) {
        await getCurrentPosition(context)
            .then((value) async => await turnOnAllNotification());
        await getAllFromFirebase();
        emit(InternertConectionState());
      } else {
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).noInternet,
            ),
            backgroundColor: Color(0xFF57A7A2),
          ),
        );
        if (box.read('fajr') == null) {
          defalutPrayerTimes().then((value) {
            turnOnAllNotification();
          });
        }
        await turnOnAllNotification();
        emit(NoInternetConnectionState());
      }
    });


    emit(InitAppState());
  }

  cancelEqama({
    required int id,
  }) {
    cancel(id);
    cancel(id + 1);
    cancel(id + 2);
    cancel(id + 3);
    cancel(id + 4);
    emit(CancelEqamaState());
  }

// getHijriDate()async{
//   var hijriDate = await HijriCalendar.now();
//   box.write('hijriDate', hijriDate);
//   emit(GetHijriDateState());
// }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title!),
    //     content: Text(body!),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => home(),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    //);
  }
}

class PrayerTimeHour {
  int hour;
  int minute;
  PrayerTimeHour(this.hour, this.minute);
}
