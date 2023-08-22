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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location permissions are denied')));
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

  getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude,localeIdentifier: 'ar'
      );
      List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude,localeIdentifier: 'en'
      );
      Placemark place = placemarks[0];
      currentAddress =
      "${place.subAdministrativeArea}";
      await box.write('addressAr', currentAddress);
      await box.write('addressEn', placemark[0].subAdministrativeArea);

      emit(AppGetLocationSuccessState(
          address: currentAddress,
          position: currentPosition
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(AppGetLocationErrorState(
          e.toString()
      ));
    }
  }

  var prayerTimes;
  var prayerNames;

  getPrayerTimes({required double latitude,
    required double longitude,
  }) async {
    var now = DateTime.now();
    var timez = now.timeZoneOffset;
    print(timez);
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

    await box.write('position', currentPosition.latitude.toString() + ',' +
        currentPosition.longitude.toString());

    calculateJommaHours();
    calculateNightThireds();


    emit(
        AppGetPrayerTimeSuccessState(
          fajr: prayerTimes[0],
          sunrise: prayerTimes[1],
          dhuhr: prayerTimes[2],
          asr: prayerTimes[3],
          sunset: prayerTimes[4],
          maghrib: prayerTimes[5],
          isha: prayerTimes[6],
        )
    );
    return prayerTimes;
  }


  defalutPrayerTimes() async {
    PrayerTimes prayers = PrayerTimes();
    var offsets = [0, 0, 0, 0, 0, 0, 0];
    prayers.tune(offsets);
    prayers.setCalcMethod(prayers.Makkah);
    // get prayer times in suaid arabia for the current date

    prayerTimes = prayers.getPrayerTimes(
        DateTime.now(), 24.641176, 46.726024, 3.0);
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

    await box.write('position', currentPosition.latitude.toString() + ',' +
        currentPosition.longitude.toString());

    calculateJommaHours();
    calculateNightThireds();


    emit(
        AppDefaultPrayerTimeSuccessState(

        )
    );
    return prayerTimes;
  }

  get local=>isArabic()?'ar':'en';
  //time = '5:30'
  // loclaiztion time = '٥:٣٠'

  String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    debugPrint("$input");
    return input;
  }


  parsPrayerTime(String time) {
    var timeEn=replaceArabicNumber(time);
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
    var strSunrise = DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' +
        sunriseT;
    var strDhuhr = DateFormat('yyyy-MM-dd', 'en').format(now) + ' ' + dhuhr;
    DateTime sunrise = DateTime.parse(strSunrise);
    DateTime noon = DateTime.parse(strDhuhr);
    int totalMinutes = noon
        .difference(sunrise)
        .inMinutes;
    var hourDuration = (totalMinutes / 5);

    for (int i = 0; i < 5; i++) {
      var hourStart = sunrise.add(
          Duration(minutes: (hourDuration * i).toInt()));
      var hourEnd = hourStart.add(Duration(minutes: hourDuration.toInt()));
      String title = 'Hour ${i + 1}';
      if(i==4)
        hourEnd=hourEnd.add(Duration(minutes: -1));

      var hourStartStr = DateFormat('hh:mm','en').format(hourStart);
      var hourEndStr = DateFormat('hh:mm','en').format(hourEnd);
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
    DateTime fajrTime = parsPrayerTime(fajr).add(Duration(days:1));
    var totalMinutes = fajrTime
        .difference(sunsetTime)
        .inSeconds;
    var hourDuration = (totalMinutes ~/ 3);
   // print('hourDuration:$hourDuration');
    var hourStart1=sunsetTime;
    var hourEnd1=sunsetTime.add(Duration(seconds:hourDuration));

    var hourStart2=hourEnd1.add(Duration(seconds:60));
    var hourEnd2= hourStart2.add(Duration(seconds:hourDuration));

    var hourStart3=hourEnd2.add(Duration(seconds:60));
    var hourEnd3= fajrTime;

    var hourStartStr1 = DateFormat('hh:mm','en').format(hourStart1);
    var hourEndStr1 = DateFormat('hh:mm','en').format(hourEnd1);
    await box.write('StartNightThirds1', hourStartStr1);
    await box.write('EndNightThirds1', hourEndStr1);
    var hourStartStr2 = DateFormat('hh:mm','en').format(hourStart2);
    var hourEndStr2 = DateFormat('hh:mm','en').format(hourEnd2);
    await box.write('StartNightThirds2', hourStartStr2);
    await box.write('EndNightThirds2', hourEndStr2);
    var hourStartStr3 = DateFormat('hh:mm','en').format(hourStart3);
    var hourEndStr3 = DateFormat('hh:mm','en').format(hourEnd3);
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
    var strPrayerTime = '${DateFormat('yyyy-MM-dd', 'en').format(now)} ' +
        prayerTim;
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


    InitializationSettings initializationSettings = InitializationSettings(


      android: initializationSettingsAndroid,
    );
    checkAndroid();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotificationResponse,


    );
    emit(InitializeNotificationState());
  }

  /// Set right date and time for notifications
  tz.TZDateTime _convertTime(int hour, int minutes, int day, bool repeatWeekly,
      bool repeatDaily) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now
          .year,
      now
          .month,
      day,
      hour,
      minutes,


    );
    if (scheduleDate.isBefore(now)) {

        scheduleDate = scheduleDate.add(Duration(days: 1));

    }
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


    required int id,
    required String title,
    required String body,
    required bool weekly,
    required bool daily,
    //required String sound,
  }) async {
    emit(ScheduledNotificationLoadingState());
 var time= _convertTime(hour, minutes, day, weekly, daily);

    await flutterLocalNotificationsPlugin.zonedSchedule(
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
      // matchDateTimeComponents:
      // weekly? DateTimeComponents.dayOfWeekAndTime :
      // DateTimeComponents.time,
      payload: 'item x',

    ).then((value) {
      emit(ScheduledNotificationSuccessState());
      debugPrint('Notification scheduled');
    }).catchError((error) {
      emit(ScheduledNotificationErrorState(error.toString()));
      debugPrint('$error');
      debugPrint('Notification scheduled error');
    });
  }








// Helper function to get the next instance of Friday at 10:00 AM
  tz.TZDateTime _nextInstanceOfFridayTenAM(
     day, int hour,int minute
      ) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  // secheduledWeeklyNotification
  secheduledWeeklyNotification({
    required int hour,
    required int minutes,
    required int day,
    required int id,
    required String title,
    required String body,
    required bool weekly,
    required bool daily,
  }) async {
    var time =_nextInstanceOfFridayTenAM(day,hour,minutes);
    var androidDetails = AndroidNotificationDetails(
        'sechudle id', 'sechudleChanel',
        channelDescription: 'channelDescription weekly',
        playSound: true,
        icon: '@mipmap/launcher_icon',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        priority: Priority.high,
        importance: Importance.max,
    );

    var generalNotificationDetails =
    NotificationDetails(android: androidDetails);
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      time,
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime ,
      androidAllowWhileIdle: false,



    ).then((value) {
      emit(ScheduledNotificationSuccessState());
      debugPrint('Notification scheduled');
    }).catchError((error) {
      emit(ScheduledNotificationErrorState(error.toString()));
      debugPrint('$error');
      debugPrint('Notification scheduled error');
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


  var hourController;
  var minuteController;

  var hour_reminder;
  var minute_reminder;

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    emit(OnSelectNotificationState());
    return Future.value(0);
  }

  void onDidReceiveLocalNotification(int id, String title, String body,
      String payload, BuildContext context) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => quranApp()),

                    );
                  },
                )
              ],
            ));
    void removeReminder(int notificationId) {
      flutterLocalNotificationsPlugin.cancel(notificationId);
    }
  }


  void onDidReceiveLocalNotificationResponse(NotificationResponse details) {
    print('Notification clicked');
    emit(OnDidReceiveLocalNotificationResponseState());
  }


  /// must call it from view after getContext is initialized to show dialog message
  checkAndroid() async {
    if (!(await Permission.notification
        .request()
        .isGranted) && Platform.isAndroid) {
      print('Permission not granted');
      openAppSettings();
      emit(PermissionNotGrantedState());
    } else {
      print('Permission granted');
      emit(PermissionGrantedState());
    }
  }

// execute if app in background
  Future<void> _messageHandler(RemoteMessage message) async {
    // Data notificationMessage = Data.fromJson(message.data);
    print('notification from background : ${message.toMap()}');
    print('notification from background : ${message.data}');
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


  surahElKahfNotification() {

    secheduledWeeklyNotification(
        hour: parsPrayerTime(box.read('dhuhr')).subtract(Duration(hours: 1)).hour,
        minutes: parsPrayerTime(box.read('dhuhr')).subtract(Duration(hours: 1)).minute,


        day: DateTime.friday,
        id: 1,
        title: 'سورة الكهف',
        body: 'قراءة سورة الكهف ',
        weekly: true,
        daily: false,
      );

    emit(SurahElkahfNotificationState());
  }

  earlyJoumaHourNotification() {

    secheduledWeeklyNotification(
        hour:
        box.read('StartprayerHour0')!=null?parsPrayerTime(box.read('StartprayerHour0')).hour:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).hour:6,
        minutes: box.read('StartprayerHour0')!=null?parsPrayerTime(box.read('StartprayerHour0')).minute:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).minute:0,
        day: DateTime.friday,
        id: 2,
        title: 'الساعه الأولي',
        body: 'كمن قرب بدنه',
        weekly: true,
        daily: false,
      );
    secheduledWeeklyNotification(
        hour: box.read('StartprayerHour1')!=null?parsPrayerTime(box.read('StartprayerHour1')).hour:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:1,minutes: 34)).hour:7,
        minutes: box.read('StartprayerHour1')!=null?parsPrayerTime(box.read('StartprayerHour1')).minute:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:1,minutes: 34)).minute:0,
        day: DateTime.friday,
        id: 3,
        title: 'الساعه الثانيه',
        body: 'كمن قرب بقرة',
        weekly: true,
        daily: false,
      );
    secheduledWeeklyNotification(
        hour: box.read('StartprayerHour2')!=null?parsPrayerTime(box.read('StartprayerHour2')).hour:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:3,minutes: 8)).hour:9,
        minutes: box.read('StartprayerHour2')!=null?parsPrayerTime(box.read('StartprayerHour2')).minute:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:3,minutes: 8)).minute:0,
        day: DateTime.friday,
        id: 4,
        title: 'الساعه الثالثه',
        body: 'كمن قرب كبش اقرن',
        weekly: true,
        daily: false,
      );

    secheduledWeeklyNotification(
        hour: box.read('StartprayerHour3')!=null?parsPrayerTime(box.read('StartprayerHour3')).hour:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:4,minutes: 42)).hour:10,
        minutes: box.read('StartprayerHour3')!=null?parsPrayerTime(box.read('StartprayerHour3')).minute:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:4,minutes: 42)).minute:0,
        day: DateTime.friday,
        id: 5,
        title: 'الساعه الرابعه',
        body: 'كمن قرب دجاجة',
        weekly: true,
        daily: false,
      );
    secheduledWeeklyNotification(
        hour: box.read('StartprayerHour4')!=null?parsPrayerTime(box.read('StartprayerHour4')).hour:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:6,minutes: 16)).hour:12,
        minutes: box.read('StartprayerHour4')!=null?parsPrayerTime(box.read('StartprayerHour4')).minute:
        box.read('sunrise')!=null?parsPrayerTime(box.read('sunrise')).add(Duration(hours:6,minutes: 16)).minute:0,
        day: DateTime.friday,
        id: 6,
        title: 'الساعه الخامسه',
        body: 'كمن قرب بيضة',
        weekly: true,
        daily: false,
      );

    emit(EarlyJoumaHourNotificationState());
  }

  nightPrayerNotification({required day,required id}) {

    scheduledNotification(
      hour: box.read('StartNightThirds3')!=null?parsPrayerTime(box.read('StartNightThirds3')).hour:2,
      minutes: box.read('StartNightThirds3')!=null?parsPrayerTime(box.read('StartNightThirds3')).minute:0,

      day: day,
      id: id,
      title: 'الثلث الاخير من الليل',
      body: 'قم وناجي الرحمن',
      weekly: false,
      daily: true,
    );

    emit(NightPrayerNotificationState());
  }

  mondayThursdayNotification() {

      secheduledWeeklyNotification(
        hour:
        box.read('maghrib')!=null?
        parsPrayerTime(box.read('maghrib')).add(Duration(hours: 1)).hour:18,
        minutes: box.read('maghrib')!=null?
        parsPrayerTime(box.read('maghrib')).add(Duration(hours: 1)).minute:0,
        day: DateTime.sunday,
        id: 8,
        title: 'صيام الاثنين',
        body: 'صيام الاثنين',
        weekly: true,
        daily: false,
      );


      secheduledWeeklyNotification(
        hour:
        box.read('maghrib') != null ?
        parsPrayerTime(box.read('maghrib'))
            .add(Duration(hours: 1))
            .hour : 18,
        minutes: box.read('maghrib') != null ?
        parsPrayerTime(box.read('maghrib'))
            .add(Duration(hours: 1))
            .minute : 0,
        day: DateTime.wednesday,
        id: 9,
        title: 'صيام الخميس',
        body: 'صيام الخميس',
        weekly: true,
        daily: false,
      );

    emit(FastingMondayAndThursdayNotificationState());
  }

  duhaPrayerNotification({day, id}) {
    if (box.read('dhuhr') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 30))
            .hour,
        minutes: parsPrayerTime(box.read('dhuhr'))
            .subtract(Duration(minutes: 30))
            .minute,
        day: day,
        id: id,
        title: 'صلاة الضحي',
        body: ' تذكير صلاة الضحي',
        weekly: false,
        daily: true,
      );
    }
    emit(MornPrayerNotificationState());
  }

  azkarNotifcation({ day, id}
      ) {
    if (box.read('sunrise') != null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('sunrise'))
            .add(Duration(minutes: 3))
            .hour,
        // 20
        minutes: parsPrayerTime(box.read('sunrise'))
            .add(Duration(minutes: 3))
            .minute,
        // 20
        day: day,
        id: id,
        title: 'أذكار الصباح',
        body: ' تذكير أذكار الصباح',
        weekly: false,
        daily: true,
      );
    }
    if(box.read('asr')!=null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr'))
            .add(Duration(minutes: 30))
            .hour,
        // 20
        minutes: parsPrayerTime(box.read('asr'))
            .add(Duration(minutes: 30))
            .minute,
        // 20
        day: day,
        id: id+1,
        title: 'أذكار المساء',
        body: ' تذكير أذكار المساء',
        weekly: false,
        daily: true,
      );
    }
    emit(AzkarNotificationState());
  }

  azanNotification({day, id}) {
    if(box.read('fajr')!=null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('fajr')).hour,
        minutes: parsPrayerTime(box.read('fajr')).minute,
        day: day,
        id: id,
        title: 'صلاة الفجر',
        body: ' حان الأن موعد صلاة الفجر',
        weekly: false,
        daily: true,
      );
    }
    if(box.read('dhuhr')!=null) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('dhuhr')).hour,
      minutes: parsPrayerTime(box.read('dhuhr')).minute,
      day:day,
      id: id+1,
      title: 'صلاة الظهر',
      body: ' حان الأن موعد صلاة الظهر',
      weekly: false,
      daily: true,
    );
}
    if(box.read('asr')!=null) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('asr')).hour,
      minutes: parsPrayerTime(box.read('asr')).minute,
      day: day,
      id: id+2 ,
      title: 'صلاة العصر',
      body: ' حان الأن موعد صلاة العصر',
      weekly: false,
      daily: true,
    );
}
    if(box.read('maghrib')!=null) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('maghrib')).hour,
      minutes: parsPrayerTime(box.read('maghrib')).minute,
      day: day,
      id: id+3,
      title: 'صلاة المغرب',
      body: ' حان الأن موعد صلاة المغرب',
      weekly: false,
      daily: true,
    );
}
    if(box.read('isha')!=null) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('isha')).hour,
      minutes: parsPrayerTime(box.read('isha')).minute,
      day:day,
      id: id+4,
      title: 'صلاة العشاء',
      body: ' حان الأن موعد صلاة العشاء',
      weekly: false,
      daily: true,
    );
}
    if(box.read('sunrise')!=null) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('sunrise')).hour,
      minutes: parsPrayerTime(box.read('sunrise')).minute,
      day: DateTime
          .now()
          .day,
      id: id+5,
      title: 'صلاة الشروق',
      body: 'حان الأن موعد صلاة الشروق',
      weekly: false,
      daily: true,
    );
}

    emit(AzanNotificationState());
  }

  prayerTimeApproachingNotification({ day, id}
      ) {
    if(box.read('fajr')!=null&&

    box.read('dhuhr')!=null&&
    box.read('asr')!=null&&
    box.read('maghrib')!=null&&
    box.read('isha')!=null&&
    box.read('sunrise')!=null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('fajr'))
            .subtract(Duration(minutes: 15))
            .hour,
        minutes: parsPrayerTime(box.read('fajr'))
            .subtract(Duration(minutes: 15))
            .minute,
        day: day,
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
        id: id+1,
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
        id: id+2,
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
        id: id+3,
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
        id: id+4,
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
        id: id+5,
        title: 'صلاة الشروق',
        body: 'اقتربت صلاة الشروق',
        weekly: false,
        daily: true,
      );
    }
    emit(PrayerTimeApproachingNotificationState());
  }
  Eqama({day, id}) {
    if(box.read('fajr')!=null&&
        box.read('dhuhr')!=null&&
        box.read('asr')!=null&&
        box.read('maghrib')!=null&&
        box.read('isha')!=null
        ) {
    scheduledNotification(
      hour: parsPrayerTime(box.read('fajr'))
          .add(Duration(minutes: 3))
          .hour,
      minutes: parsPrayerTime(box.read('fajr'))
          .add(Duration(minutes: 3))
          .minute,
      day: day,
      id: id,
      title: ' الدعاء بين الاذان والاقامة',
      body: '  دعاء',
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: parsPrayerTime(box.read('dhuhr'))
          .add(Duration(minutes: 3))
          .hour,
      minutes: parsPrayerTime(box.read('dhuhr'))
          .add(Duration(minutes: 3))
          .minute,
      day: day,
      id: id+1,
      title: ' الدعاء بين الاذان والاقامة',
      body: '  دعاء',
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: parsPrayerTime(box.read('asr'))
          .add(Duration(minutes: 3))
          .hour,
      minutes: parsPrayerTime(box.read('asr'))
          .add(Duration(minutes: 3))
          .minute,
      day: day,
      id: id+2,
      title: ' الدعاء بين الاذان والاقامة',
      body: '  دعاء',
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: parsPrayerTime(box.read('maghrib'))
          .add(Duration(minutes: 3))
          .hour,
      minutes: parsPrayerTime(box.read('maghrib'))
          .add(Duration(minutes: 3))
          .minute,
      day: day,
      id: id+3,
      title: ' الدعاء بين الاذان والاقامة',
      body: '  دعاء',
      weekly: false,
      daily: true,
    );
    scheduledNotification(
      hour: parsPrayerTime(box.read('isha'))
          .add(Duration(minutes: 3))
          .hour,
      minutes: parsPrayerTime(box.read('isha'))
          .add(Duration(minutes: 3))
          .minute,
      day: day,
      id: id+4,
      title: ' الدعاء بين الاذان والاقامة',
      body: '  دعاء',
      weekly: false,
      daily: true,

    );
    }

    emit(SetEqamaState());
  }


  quranNotification(
      day,id
      ) {
    if(
        box.read('asr')!=null

        ) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr'))
            .add(minutes: 30)
            .hour,
        minutes: parsPrayerTime(box.read('asr'))
            .add(minutes: 30)
            .minute,
        day: day,
        id: id,
        title: 'قراءه القرآن الكريم',
        body: 'قراءة الورد اليومي',
        weekly: true,
        daily: false,
      );
    }
    emit(QuranNotificationState());
  }


  cancelSurahElKahfNotification() {
    cancel(1);
    emit(CancelSurahElKahfNotificationState());
  }

  cancelEarlyJoumaHourNotification() {
    cancel(2);
    cancel(3);
    cancel(4);
    cancel(5);
    cancel(6);
    emit(CancelEarlyJoumaHourNotificationState());
  }

  cancelNightPrayerNotification(
  {required id}
      ) {
    cancel(id);

    emit(CancelNightPrayerNotificationState());
  }

  cancelMondayThursdayNotification() {
    cancel(8);
    cancel(9);
    emit(CancelFastingMondayAndThursdayNotificationState());
  }

  cancelDuhaPrayerNotification(
  {required id}

      ) {
    cancel(id);
    emit(CancelMornPrayerNotificationState());
  }

  cancelAzkarNotifcation(
  {required id}
      ) {
    cancel(id);
    cancel(id+1);
    emit(CancelAzkarNotificationState());
  }

  cancelAzanNotification() {
    cancel(13);
    cancel(14);
    cancel(15);
    cancel(16);
    cancel(17);
    cancel(18);
    emit(CancelAzanNotificationState());
  }

  cancelPrayerTimeApproachingNotification(
  {required id}
      ) {
    cancel(id);
    cancel(id+1);
    cancel(id+2);
    cancel(id+3);
    cancel(id+4);
    cancel(id+5);
    emit(CancelPrayerTimeApproachingNotificationState());
  }

  cancelQuranNotification() {
    cancel(25);
    emit(CancelQuranNotificationState());
  }

  lastHourFridayNotification() {
      secheduledWeeklyNotification(
      hour: parsPrayerTime(box.read('maghrib'))
            .subtract(Duration(hours: 1))
            .hour ?? 6,
        minutes: parsPrayerTime(box.read('maghrib'))
            .subtract(Duration(hours: 1))
            .minute ?? 10,

        day: DateTime.friday,
        id: 30,
        title: 'وقال ربكم ادعوني استجب لكم',
        body: "آخر ساعة من يوم الجمعة وهي ساعة إجابة فاغتنمها",
        weekly: true,
        daily: false,
      );

    emit(LastHourFridayNotificationState());
  }

  cancelLastHourFridayNotification() {
    cancel(30);
    emit(CancelLastHourFridayNotificationState());
  }

  prayOnProphetNotification() {
    scheduledNotification(
      hour: box.read('fajr') == null
          ? 5
          : parsPrayerTime(box.read('fajr')).add(Duration(minutes: 10)).hour,
      minutes: box.read('fajr') == null
          ? 0
          : parsPrayerTime(box.read('fajr')).add(Duration(minutes: 10)).minute,
      day: DateTime.friday,
      id: 31,
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
      day: DateTime.now().day,
      id: 41,
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
      day: DateTime.now().day,
      id: 51,
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
          : parsPrayerTime(box.read('maghrib')).add(Duration(minutes: 10)).minute,
      day: DateTime.now().day,
      id: 61,
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
      day: DateTime.now().day,
      id: 71,
      title: 'الدعاء',
      body: "صلي على النبي",
      weekly: false,
      daily: true,
    );



    emit(PrayOnProphetNotificationState());
  }

  cancelPrayOnProphetNotification() {
    cancel(31);
    cancel(41);
    cancel(51);
    cancel(61);
    cancel(71);

    emit(CancelPrayOnProphetNotificationState());
  }



  dailyQuranNotification({day, id}) {
    if(box.read('asr')!=null) {
      scheduledNotification(
        hour: parsPrayerTime(box.read('asr'))
            .add(Duration(minutes: 30))
            .hour ?? 15,
        minutes: parsPrayerTime(box.read('asr'))
            .add(Duration(minutes: 30))
            .minute ?? 30,
        day:day,
        id: id,
        title: 'القرآن الكريم',
        body: "قراءة الورد اليومي",
        weekly: false,
        daily: true,
      );
    }
    emit(DailyQuranNotificationState());
  }

  cancelDailyQuranNotification(
  {required id}
      ) {
    cancel(id);
    emit(CancelDailyQuranNotificationState());
  }

  turnOnAllNotification() {
    var value1 = CacheHelper.getData(key: 'readSurahElKahf');
    var value2 = CacheHelper.getData(key: 'joumaaHours');
    var value3 = CacheHelper.getData(key: 'doaaLastHour');
    var value4 = CacheHelper.getData(key: 'prayOnProphet');
    var value5 = CacheHelper.getData(key: 'duhaPrayer');
    var value6 = CacheHelper.getData(key: 'mondayThursday');
    var value7 = CacheHelper.getData(key: 'eqama');
    var value8 = CacheHelper.getData(key: 'nightPrayer');
    var value9 = CacheHelper.getData(key: 'dailyQuran');
    var value10 = CacheHelper.getData(key: 'morningEvening');
    var value11 = CacheHelper.getData(key: 'approachingPrayers');


    value1??true? surahElKahfNotification():cancelSurahElKahfNotification();
    value2??true? earlyJoumaHourNotification():cancelEarlyJoumaHourNotification();

    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 0)).day,id:100):cancelNightPrayerNotification(id:100);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 1)).day,id:101):cancelNightPrayerNotification(id:101);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 2)).day,id:102):cancelNightPrayerNotification(id:102);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 3)).day,id:103):cancelNightPrayerNotification(id:103);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 4)).day,id:104):cancelNightPrayerNotification(id:104);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 5)).day,id:105):cancelNightPrayerNotification(id:105);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 6)).day,id:106):cancelNightPrayerNotification(id:106);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 7)).day,id:107):cancelNightPrayerNotification(id:107);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 8)).day,id:108):cancelNightPrayerNotification(id:108);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 9)).day,id:109):cancelNightPrayerNotification(id:109);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 10)).day,id:110):cancelNightPrayerNotification(id:110);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:11)).day,id:111):cancelNightPrayerNotification(id:111);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:12)).day,id:112):cancelNightPrayerNotification(id:112);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:13)).day,id:113):cancelNightPrayerNotification(id:113);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:14)).day,id:114):cancelNightPrayerNotification(id:114);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:15)).day,id:115):cancelNightPrayerNotification(id:115);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:16)).day,id:116):cancelNightPrayerNotification(id:116);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:17)).day,id:117):cancelNightPrayerNotification(id:117);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:18)).day,id:118):cancelNightPrayerNotification(id:118);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days:19)).day,id:119):cancelNightPrayerNotification(id:119);
    value8??true? nightPrayerNotification(day: DateTime.now().add(Duration(days: 20)).day,id:120):cancelNightPrayerNotification(id:120);



    value6??true? mondayThursdayNotification():cancelMondayThursdayNotification();

    // duhaPrayerNotification();

    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 0)).day,id:121):cancelDuhaPrayerNotification(id:121);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 1)).day,id:122):cancelDuhaPrayerNotification(id:122);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 2)).day,id:123):cancelDuhaPrayerNotification(id:123);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 3)).day,id:124):cancelDuhaPrayerNotification(id:124);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 4)).day,id:125):cancelDuhaPrayerNotification(id:125);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 5)).day,id:126):cancelDuhaPrayerNotification(id:126);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 6)).day,id:127):cancelDuhaPrayerNotification(id:127);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 7)).day,id:128):cancelDuhaPrayerNotification(id:128);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 8)).day,id:129):cancelDuhaPrayerNotification(id:129);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 9)).day,id:130):cancelDuhaPrayerNotification(id:130);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 10)).day,id:131):cancelDuhaPrayerNotification(id:131);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:11)).day,id:132):cancelDuhaPrayerNotification(id:132);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:12)).day,id:134):cancelDuhaPrayerNotification(id:134);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:13)).day,id:135):cancelDuhaPrayerNotification(id:135);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:14)).day,id:136):cancelDuhaPrayerNotification(id:136);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:15)).day,id:137):cancelDuhaPrayerNotification(id:137);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:16)).day,id:138):cancelDuhaPrayerNotification(id:138);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:17)).day,id:139):cancelDuhaPrayerNotification(id:139);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:18)).day,id:140):cancelDuhaPrayerNotification(id:140);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days:19)).day,id:141):cancelDuhaPrayerNotification(id:141);
    value5??true? duhaPrayerNotification(day: DateTime.now().add(Duration(days: 20)).day,id:142):cancelDuhaPrayerNotification(id:142);





    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 0)).day,id:143):cancelAzkarNotifcation(id: 143);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 1)).day,id:145):cancelAzkarNotifcation(id:145);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 2)).day,id:147):cancelAzkarNotifcation(id:147);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 3)).day,id:149):cancelAzkarNotifcation(id:149);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 4)).day,id:151):cancelAzkarNotifcation(id:151);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 5)).day,id:153):cancelAzkarNotifcation(id:153);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 6)).day,id:155):cancelAzkarNotifcation(id:155);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 7)).day,id:157):cancelAzkarNotifcation(id:157);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 8)).day,id:159):cancelAzkarNotifcation(id:159);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 9)).day,id:161):cancelAzkarNotifcation(id:161);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 10)).day,id:163):cancelAzkarNotifcation(id:163);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:11)).day,id:165):cancelAzkarNotifcation(id:165);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:12)).day,id:167):cancelAzkarNotifcation(id:167);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:13)).day,id:169):cancelAzkarNotifcation(id:169);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:14)).day,id:171):cancelAzkarNotifcation(id:171);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:15)).day,id:173):cancelAzkarNotifcation(id:173);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:16)).day,id:175):cancelAzkarNotifcation(id:175);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:17)).day,id:177):cancelAzkarNotifcation(id:177);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:18)).day,id:179):cancelAzkarNotifcation(id:179);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days:19)).day,id:181):cancelAzkarNotifcation(id:181);
    value10??true? azkarNotifcation(day: DateTime.now().add(Duration(days: 20)).day,id:183):cancelAzkarNotifcation(id:183);





    setAzanNotification();


    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 0)).day,id:430):cancelPrayerTimeApproachingNotification(id:430);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 1)).day,id:436):cancelPrayerTimeApproachingNotification(id:436);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 2)).day,id:442):cancelPrayerTimeApproachingNotification(id:442);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 3)).day,id:448):cancelPrayerTimeApproachingNotification(id:448);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 4)).day,id:454):cancelPrayerTimeApproachingNotification(id:454);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 5)).day,id:460):cancelPrayerTimeApproachingNotification(id:460);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 6)).day,id:466):cancelPrayerTimeApproachingNotification(id:466);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 7)).day,id:472):cancelPrayerTimeApproachingNotification(id:472);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 8)).day,id:478):cancelPrayerTimeApproachingNotification(id:478);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 9)).day,id:484):cancelPrayerTimeApproachingNotification(id:484);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 10)).day,id:490):cancelPrayerTimeApproachingNotification(id:490);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:11)).day,id:496):cancelPrayerTimeApproachingNotification(id:496);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:12)).day,id:502):cancelPrayerTimeApproachingNotification(id:502);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:13)).day,id:508):cancelPrayerTimeApproachingNotification(id:508);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:14)).day,id:514):cancelPrayerTimeApproachingNotification(id:514);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:15)).day,id:520):cancelPrayerTimeApproachingNotification(id:520);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:16)).day,id:526):cancelPrayerTimeApproachingNotification(id:526);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:17)).day,id:532):cancelPrayerTimeApproachingNotification(id:532);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:18)).day,id:538):cancelPrayerTimeApproachingNotification(id:538);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days:19)).day,id:544):cancelPrayerTimeApproachingNotification(id:544);
    value11??true? prayerTimeApproachingNotification(day: DateTime.now().add(Duration(days: 20)).day,id:550):cancelPrayerTimeApproachingNotification(id:550);
    // value9? quranNotification():null;
    value3??true? lastHourFridayNotification():cancelLastHourFridayNotification();


    value4??true? prayOnProphetNotification():cancelPrayOnProphetNotification();

    value7??true? Eqama(day: DateTime.now().add(Duration(days: 0)).day,id:600):cancelEqama(id:600);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 1)).day,id:606):cancelEqama(id:606);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 2)).day,id:612):cancelEqama(id:612);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 3)).day,id:618):cancelEqama(id:618);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 4)).day,id:624):cancelEqama(id:624);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 5)).day,id:630):cancelEqama(id:630);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 6)).day,id:636):cancelEqama(id:636);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 7)).day,id:642):cancelEqama(id:642);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 8)).day,id:648):cancelEqama(id:648);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 9)).day,id:654):cancelEqama(id:654);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 10)).day,id:660):cancelEqama(id:660);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:11)).day,id:666):cancelEqama(id:666);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:12)).day,id:672):cancelEqama(id:672);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:13)).day,id:678):cancelEqama(id:678);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:14)).day,id:684):cancelEqama(id:684);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:15)).day,id:690):cancelEqama(id:690);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:16)).day,id:696):cancelEqama(id:696);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:17)).day,id:702):cancelEqama(id:702);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:18)).day,id:708):cancelEqama(id:708);
    value7??true? Eqama(day: DateTime.now().add(Duration(days:19)).day,id:714):cancelEqama(id:714);
    value7??true? Eqama(day: DateTime.now().add(Duration(days: 20)).day,id:720):cancelEqama(id:720);




    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 0)).day,id:800):cancelDailyQuranNotification(id:800);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 1)).day,id:801):cancelDailyQuranNotification(id:801);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 2)).day,id:802):cancelDailyQuranNotification(id:802);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 3)).day,id:803):cancelDailyQuranNotification(id:803);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 4)).day,id:804):cancelDailyQuranNotification(id:804);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 5)).day,id:805):cancelDailyQuranNotification(id:805);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 6)).day,id:806):cancelDailyQuranNotification(id:806);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 7)).day,id:807):cancelDailyQuranNotification(id:807);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 8)).day,id:808):cancelDailyQuranNotification(id:808);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 9)).day,id:809):cancelDailyQuranNotification(id:809);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 10)).day,id:810):cancelDailyQuranNotification(id:810);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:11)).day,id:811):cancelDailyQuranNotification(id:811);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:12)).day,id:812):cancelDailyQuranNotification(id:812);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:13)).day,id:813):cancelDailyQuranNotification(id:813);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:14)).day,id:814):cancelDailyQuranNotification(id:814);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:15)).day,id:815):cancelDailyQuranNotification(id:815);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:16)).day,id:816):cancelDailyQuranNotification(id:816);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:17)).day,id:817):cancelDailyQuranNotification(id:817);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:18)).day,id:818):cancelDailyQuranNotification(id:818);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days:19)).day,id:819):cancelDailyQuranNotification(id:819);
    value9??true? dailyQuranNotification(day: DateTime.now().add(Duration(days: 20)).day,id:820):cancelDailyQuranNotification(id:820);









    emit(TurnOnAllNotificationState());
  }

  setAzanNotification() {
    azanNotification(day: DateTime.now().add(Duration(days: 0)).day,id:300);
    azanNotification(day: DateTime.now().add(Duration(days: 1)).day,id:306);
    azanNotification(day: DateTime.now().add(Duration(days: 2)).day,id:312);
    azanNotification(day: DateTime.now().add(Duration(days: 3)).day,id:318);
    azanNotification(day: DateTime.now().add(Duration(days: 4)).day,id:324);
    azanNotification(day: DateTime.now().add(Duration(days: 5)).day,id:330);
    azanNotification(day: DateTime.now().add(Duration(days: 6)).day,id:336);
    azanNotification(day: DateTime.now().add(Duration(days: 7)).day,id:342);
    azanNotification(day: DateTime.now().add(Duration(days: 8)).day,id:348);
    azanNotification(day: DateTime.now().add(Duration(days: 9)).day,id:354);
    azanNotification(day: DateTime.now().add(Duration(days: 10)).day,id:360);
    azanNotification(day: DateTime.now().add(Duration(days:11)).day,id:366);
    azanNotification(day: DateTime.now().add(Duration(days:12)).day,id:372);
    azanNotification(day: DateTime.now().add(Duration(days:13)).day,id:378);
    azanNotification(day: DateTime.now().add(Duration(days:14)).day,id:384);
    azanNotification(day: DateTime.now().add(Duration(days:15)).day,id:390);
    azanNotification(day: DateTime.now().add(Duration(days:16)).day,id:396);
    azanNotification(day: DateTime.now().add(Duration(days:17)).day,id:402);
    azanNotification(day: DateTime.now().add(Duration(days:18)).day,id:408);
    azanNotification(day: DateTime.now().add(Duration(days:19)).day,id:414);
    azanNotification(day: DateTime.now().add(Duration(days: 20)).day,id:420);


    emit(SetAzanNotificationState());
  }


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var message;
  getAdminMassagesFromFirebase(
      {
        required String collectionName,
        required String docName,
      }
      ) async {
    await firestore.collection(collectionName).doc(docName).get().then((
        value) {
      if(value.data() != null) {
          message= value.data()!['text'];
        box.write(collectionName,message );
        collectionName == adminMessageCollectionAr?
        box.write(newAdminMessageAr, value.data()!['text']):
            collectionName == adminMessageCollectionEn?
            box.write(newAdminMessageEn, value.data()!['text']):
                null;

      }
      else {
        debugPrint(collectionName + ' is null');
      }

      emit(GetAdminMassageEnFromFirebaseState());
    });
  }
  var imageEn;
  getImageEnFromFirebaseStorage() async {
    FirebaseFirestore.instance.collection('ads_En').doc('ads_En').get().then((
        value) {
      if(value.data()!=null) {
        // imageEn = value.data()!['imageEn'];

        box.write('imageEn', value.data()!['imageEn']);
        emit(GetImageFromFirebaseStorageEnState());

      }else {
        FirebaseStorage.instance.ref().child('imageEn')
            .getDownloadURL()
            .then((value) {
          box.write('imageEn', value);
          emit(GetImageFromFirebaseStorageEnState());
        });
      }

    }
    );

  }


  getImageArFromFirebase() async {
    FirebaseFirestore.instance.collection('ads_Ar').doc('ads_Ar').get().then((
        value) {
      if(value.data()!['imageAr'] != null){
        box.write('imageAr', value.data()!['imageAr']??logoUrl);
        emit(GetImageFromFirebaseStorageState());
      }else{
        FirebaseStorage.instance.ref().child('imageAr').getDownloadURL().then((value) {
          box.write('imageAr', value??logoUrl);
          emit(GetImageFromFirebaseStorageState());
        });

      }

    });
  }

  Future getPosts(
      {
        required String collectionName,

      }
      )async {
    var box= GetStorage();

    List Links=[];
    List imageId=[];
    FirebaseFirestore.instance
        .collection(collectionName)

        .get().then((value) {
      Links=[];
      imageId=[];
      debugPrint('value is this ==> '+value.docs.toString());
      value.docs.forEach((element) {


        Links.add(element.data()['link']);

        imageId.add(element.data()['id']);


      });
      collectionName ==adsCollectionNameAr?
      box.write(keyLinksAr, Links):

      box.write(keyLinksEn, Links);



      collectionName ==adsCollectionNameAr?
      box.write(keyImageIdAr, imageId):

      box.write(keyImageIdEn, imageId);


      debugPrint(imageId.toString());
      emit(GetImageFromFirebaseStorageState());
    }).catchError((error) {
      debugPrint('error is this ==> '+error.toString());
      emit (GetImageFromFirebaseStorageErrorState());
    });


  }

  getAllFromFirebase() async {

    await getPosts(collectionName: adsCollectionNameAr);
    await getPosts(collectionName: adsCollectionNameEN);
    await getAdminMassagesFromFirebase(collectionName: adminMessageCollectionAr, docName: adminMessageDocAr);
    await getAdminMassagesFromFirebase(collectionName: adminMessageCollectionEn, docName: adminMessageDocEn);
    await getAdminMassagesFromFirebase(collectionName: jumaaHadithCollectionAr, docName: jumaaHadithDocAr);
    await getAdminMassagesFromFirebase(collectionName: jumaaHadithCollectionEn, docName: jumaaHadithDocEn);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionAr1, docName: jumaaSuinnDocAr1);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionAr2, docName: jumaaSuinnDocAr2);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionAr3, docName: jumaaSuinnDocAr3);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionEn1, docName: jumaaSuinnDocEn1);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionEn2, docName: jumaaSuinnDocEn2);
    await getAdminMassagesFromFirebase(collectionName: jumaaSuinnCollectiionEn3, docName: jumaaSuinnDocEn3);
    await getAdminMassagesFromFirebase(collectionName: nightHadithCollectionAr, docName: nightHadithDocAr);
    await getAdminMassagesFromFirebase(collectionName: nightHadithCollectionEn, docName: nightHadithDocEn);
    await getAdminMassagesFromFirebase(collectionName: forWhoCollectionNameAr, docName: forWhoDocNameAr);
    await getAdminMassagesFromFirebase(collectionName: forWhoCollectionNameEn, docName: forWhoDocNameEn);
    await getAdminMassagesFromFirebase(collectionName: privacyCollectionNameAr, docName: privacyDocNameAr);
    await getAdminMassagesFromFirebase(collectionName: privacyCollectionNameEn, docName: privacyDocNameEn);
    await getAdminMassagesFromFirebase(collectionName: contactUsCollectionName, docName: contactUsDocName);
    emit(GetAllFromFirebaseState());
  }


  initApp(context)async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
       getCurrentPosition(context).then((value) async =>
      await turnOnAllNotification()
       );
      await getAllFromFirebase();
      emit(InternertConectionState());
    } else {
      scaffoldKey.currentState!.
      showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).noInternet,
          ),
          backgroundColor: Color(0xFF57A7A2),
        ),
      );
      if(box.read('fajr')==null){
        defalutPrayerTimes().then((value) {
          turnOnAllNotification();

        }
        );


      }

      emit(NoInternetConnectionState());
    }

    emit(InitAppState());

  }

  cancelEqama(
      {
        required int id,

      }
      ) {

    cancel(id);
    cancel(id+1);
    cancel(id+2);
    cancel(id+3);
    cancel(id+4);
    emit(CancelEqamaState());
  }





// getHijriDate()async{
//   var hijriDate = await HijriCalendar.now();
//   box.write('hijriDate', hijriDate);
//   emit(GetHijriDateState());
// }

}




class PrayerTimeHour{
  int hour;
  int minute;
  PrayerTimeHour(this.hour,this.minute);

}






