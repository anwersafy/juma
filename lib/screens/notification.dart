import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';
import '../service/shared_helper.dart';

class NotificationScreeen extends StatefulWidget {
  const NotificationScreeen({super.key});

  @override
  State<NotificationScreeen> createState() => _NotificationScreeenState();
}

class _NotificationScreeenState extends State<NotificationScreeen> {
  @override
  void initState() {
    super.initState();
    CacheHelper.init();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var cubit = AppCubit.get(context);

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

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [


                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                             S.of(context).Notices,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            MaterialButton(onPressed: (){
                              Navigator.pop(context);
                            },
                                child:Transform.rotate(angle:cubit.isArabic()? 180 * 3.14 / 180:0,
                                    child: SvgPicture.asset('images/Vector.svg')) ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width:5 ,
                              ),
                              Text(
                                S.of(context).Reminder_to_read_Surat_AlKahf_on_Friday,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 45,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Switch(
                                  value: value1 ?? true,
                                  onChanged: (value) {
                                    value
                                        ? cubit.surahElKahfNotification()
                                        : cubit.cancelSurahElKahfNotification();
                                    CacheHelper.putData(
                                        key: 'readSurahElKahf', value: value);
                                  },
                                  activeColor: Color(0xFF87CBB9),
                                  activeTrackColor: Color(0xFF569DAA),
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width*0.9,
                          margin: EdgeInsets.all(10),
                          height: 60,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.9,


                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                S.of(context).Reminder_to_come_early_on_Friday,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 45,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Switch(
                                  value: value2 ?? true,
                                  onChanged: (value) {
                                    value
                                        ? cubit.earlyJoumaHourNotification()
                                        : cubit
                                            .cancelEarlyJoumaHourNotification();
                                    CacheHelper.putData(
                                        key: 'joumaaHours', value: value);
                                  },
                                  activeColor: Color(0xFF87CBB9),
                                  activeTrackColor: Color(0xFF569DAA),
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(10),
                          height: 60,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      ],
                    ),
                    width: double.infinity,
                    height: 270,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF87CBB9), Color(0xFF569DAA)],
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width:5,
                        ),
                        Text(
                          S.of(context).Remembering_to_pray_in_the_last_hour_of_Friday,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),

                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value3 ?? true,
                            onChanged: (value) {
                              value
                                  ? cubit.lastHourFridayNotification()
                                  : cubit.cancelLastHourFridayNotification();
                              CacheHelper.putData(
                                  key: 'doaaLastHour', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Reminders_to_pray_for_the_Prophet,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value4 ?? true,
                            onChanged: (value) {
                              value
                                  ? cubit.prayOnProphetNotification()
                                  : cubit.cancelPrayOnProphetNotification();
                              CacheHelper.putData(
                                  key: 'prayOnProphet', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                         S.of(context).Reminding_the_Duha_prayer,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value5 ?? true,
                            onChanged: (value) {


                              CacheHelper.putData(
                                  key: 'duhaPrayer', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).A_reminder_to_fast_on_Mondays_and_Thursdays,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value6 ?? true,
                            onChanged: (value) {
                              value
                                  ? cubit.mondayThursdayNotification()
                                  : cubit.cancelMondayThursdayNotification();
                              CacheHelper.putData(
                                  key: 'mondayThursday', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Reminder_to_do_the_night_prayers,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child:  Switch(
                            value: value8 ?? true,
                            onChanged: (value) {
                              // value
                              //     ? cubit.nightPrayerNotification()
                              //     : cubit.cancelNightPrayerNotification();
                              CacheHelper.putData(
                                  key: 'nightPrayer', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            S.of(context).Remembering_to_pray_between_the_call_to_prayer_and_the_iqama,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value7 ?? true,
                            onChanged: (value) {
                              // value
                              //     ? cubit.Eqama()
                              //     : cubit.cancelEqama();
                              CacheHelper.putData(
                                  key: 'eqama', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width:MediaQuery.of(context).size.width*0.7,
                          child: Text(
                           S.of(context).Reminder_to_read_daily_roses_from_the_Holy_Quran,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value9 ?? true,
                            onChanged: (value) {
                              // value
                              //     ? cubit.dailyQuranNotification()
                              //     : cubit.cancelDailyQuranNotification();
                              CacheHelper.putData(
                                  key: 'dailyQuran', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            S.of(context).Remembering_the_morning_and_evening_remembrances,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value10 ?? true,
                            onChanged: (value) {
                              value
                                  ? cubit.azanNotification()
                                  : cubit.cancelAzanNotification();
                              CacheHelper.putData(
                                  key: 'morningEvening', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).Reminding_the_entry_of_prayer_times,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 45,
                          height: 24,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Switch(
                            value: value11 ?? true,
                            onChanged: (value) {
                              // value
                              //     ? cubit.prayerTimeApproachingNotification()
                              //     : cubit.cancelPrayerTimeApproachingNotification();
                              CacheHelper.putData(
                                  key: 'approachingPrayers', value: value);
                            },
                            activeColor: Color(0xFF87CBB9),
                            activeTrackColor: Color(0xFF569DAA),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    width:  MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all(10),
                    height: 60,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
