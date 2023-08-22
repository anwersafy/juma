import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jumaa/quran/providers/bookmark.dart';
import 'package:jumaa/quran/providers/quran.dart';
import 'package:jumaa/quran/providers/show_overlay_provider.dart';
import 'package:jumaa/quran/providers/theme_provider.dart';
import 'package:jumaa/quran/providers/toast.dart';
import 'package:jumaa/service/shared_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'nav_bar.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await CacheHelper.init();

   tz.initializeTimeZones();


  final prefs = await SharedPreferences.getInstance();

  // var box=await Hive.openBox('prayerBox');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var prefs=CacheHelper.sharedPreferences;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<ShowOverlayProvider>(
          create: (context) => ShowOverlayProvider(),
        ),
        ChangeNotifierProvider<Quran>(
          create: (context) => Quran(prefs),
        ),
        ChangeNotifierProxyProvider<Quran, BookMarkProvider>(
          create: (context) => BookMarkProvider(prefs),
          update: (context, value, previous) =>
          previous!..update(value.currentPage),
        ),
        ChangeNotifierProxyProvider<Quran, ToastProvider>(
          create: (context) => ToastProvider(),
          update: (context, value, previous) =>
          previous!..update(value.hizbQuarter),
        ),
      ],
      child:BlocProvider(
        create: (context) => AppCubit()..initApp(context)..initializeNotification(),
        child:
        BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context,state) {
            var cubit = AppCubit.get(context);
            return MaterialApp(
              scaffoldMessengerKey: cubit.scaffoldKey,
                debugShowCheckedModeBanner: false,

                localizationsDelegates: [
                        S.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,




            locale: Locale(CacheHelper.getData(key: 'language')??'ar'),


            theme: ThemeData(
                  primaryColor: Colors.grey[800],
                ),
                home: home()
                );
          }
        ),
      ),
    );
  }
}
