import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import 'package:jumaa/component/string_manager.dart';
import 'package:jumaa/quran/quran_app.dart';
import 'package:jumaa/screens/azkar.dart';
import 'package:jumaa/screens/home_screen.dart';
import 'package:jumaa/screens/night_pray.dart';
import 'package:jumaa/screens/early_pray.dart';
import 'package:jumaa/screens/radio.dart';
import 'package:jumaa/screens/setting.dart';
import 'package:jumaa/screens/todo_in_juma.dart';
import 'package:jumaa/screens/quran/quran_screen.dart';
import 'package:jumaa/service/shared_helper.dart';
import '/generated/l10n.dart';
import 'component/widget.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var box = GetStorage();
         var newMessageAr= box.read(newAdminMessageAr);
          var newMessageEn= box.read(newAdminMessageEn);
          var oldMessageAr= box.read(oldAdminMessageAr);
          var oldMessageEn= box.read(oldAdminMessageEn);
          cubit.isArabic()?
              CacheHelper.putData(key: 'badgeAr', value: newMessageAr==oldMessageAr?false:true):
              CacheHelper.putData(key: 'badgeEn', value: newMessageEn==oldMessageEn?false:true);

          return Scaffold(
              key: cubit.scaffolKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFB9EDDD),
                        Color(0xFF87CBB9),
                        Color(0xFF57A7A2),
                        Color(0xFF569DAA),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                elevation: 10,
                leading: MaterialButton(
                    onPressed: () {
                      cubit.scaffolKey.currentState!.openDrawer();
                    },
                    child: SvgPicture.asset('images/img_menu.svg')),
                title: GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  S.of(context).Admin_message,
                                ),
                                content: Text(
                                  cubit.isArabic()
                                      ? box.read(adminMessageCollectionAr) ?? ''
                                      : box.read(adminMessageCollectionEn) ?? '',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: ()async {
                                        var newMessageAr = box.read(newAdminMessageAr) ;
                                        var newMessageEn = box.read(newAdminMessageEn) ;
                                        cubit.isArabic()?
                                        box.write(oldAdminMessageAr, newMessageAr):
                                        box.write(oldAdminMessageEn, newMessageEn);

                                          Navigator.pop(context, 'Cancel');
                                          },
                                      child: const Text('Ok')),
                                ]));
                  },
                  child:
                  cubit.isArabic()?
                  CacheHelper.getData(key: 'badgeAr')==true?
                  badges.Badge(
                      badgeContent: Text(''),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                        shape: badges.BadgeShape.circle,
                        padding: EdgeInsets.all(7),
                        elevation: 10,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/messages.svg',
                        color: Colors.white,
                        width: 30,
                        height: 30,
                      )
                  ):
                  SvgPicture.asset(
                    'assets/icons/messages.svg',
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ):
                  CacheHelper.getData(key: 'badgeEn')==true?
                  badges.Badge(
                      badgeContent: Text(''),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                        shape: badges.BadgeShape.circle,
                        padding: EdgeInsets.all(7),
                        elevation: 10,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/messages.svg',
                        color: Colors.white,
                        width: 30,
                        height: 30,
                      )
                  ):
                  SvgPicture.asset(
                    'assets/icons/messages.svg',
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await cubit.initApp(context);
                          },
                          icon: SvgPicture.asset(
                            'images/img_fluentlocation12filled.svg',
                            width: 24,
                            height: 24,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 198,
                        child: Text(
                          cubit.isArabic()
                              ? box.read('addressAr') ?? ''
                              : box.read('addressEn') ?? '',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
              body: Center(
                child: cubit.screens.elementAt(cubit.currentIndex),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(.1),
                    )
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                            icon: Image.asset("images/img_rectangle92.png",
                                width: 20,
                                height: 20,
                                color: cubit.currentIndex == 0
                                    ? Color(0xFF57A7A2)
                                    : Colors.grey),
                            label: S.of(context).Home),
                        BottomNavigationBarItem(
                            icon: Image.asset("images/img_rectangle93.png",
                                width: 20,
                                height: 20,
                                color: cubit.currentIndex == 1
                                    ? Color(0xFF57A7A2)
                                    : Colors.grey),
                            label: S.of(context).Sunnah_on_Friday),
                        BottomNavigationBarItem(
                            icon: Image.asset("images/img_rectangle120.png",
                                width: 20,
                                height: 20,
                                color: cubit.currentIndex == 2
                                    ? Color(0xFF57A7A2)
                                    : Colors.grey),
                            label:
                                S.of(context).coming_early_for_Jummah_prayer),
                        BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                                "images/img_mingcutesettings6fill.svg",
                                width: 20,
                                height: 20,
                                color: cubit.currentIndex == 3
                                    ? Color(0xFF57A7A2)
                                    : Colors.grey),
                            label: S.of(context).Settings),
                      ],
                      type: BottomNavigationBarType.fixed,
                      currentIndex: cubit.currentIndex,
                      selectedItemColor: Color(0xFF57A7A2),
                      onTap: (index) {
                        cubit.changeBottomNavBar(index);
                      },
                    ),
                  ),
                ),
              ),
              drawer: Drawer(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img_rectangle112.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 43,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'images/logo.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => quranApp()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'images/img_rectangle158.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).The_Holy_Quran,
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NightPray()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'images/img_rectangle160.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).Night_Prayer,
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RadioScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'images/img_rectangle162.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          S.of(context).Radio_Holy_Quran,
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AzkarScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'images/Rectangle 164.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                          child: Container(
                                        width: 160,
                                        height: 50,
                                        child: Text(
                                          S
                                              .of(context)
                                              .The_remembrances_of_a_Muslim,
                                          overflow: TextOverflow.visible,
                                          softWrap: true,
                                          style: TextStyle(
                                            overflow: TextOverflow.clip,
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
