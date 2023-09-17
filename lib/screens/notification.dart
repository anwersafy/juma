import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../component/string_manager.dart';
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AppCubit().turnOnAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          var surahElkahfNotificationValue =
              CacheHelper.getData(key: surahElKahfKey);
          var joumaaHoursNotificationValue =
              CacheHelper.getData(key: joumaaHoursKey);
          var doaaLastHourNotificationValue =
              CacheHelper.getData(key: doaaLastHourKey);
          var prayOnProphetNotificationValue =
              CacheHelper.getData(key: prayOnProphetKey);
          var duhaPrayerNotificationValue =
              CacheHelper.getData(key: duhaPrayerKey);
          var mondayThursdayNotificationValue =
              CacheHelper.getData(key: mondayThursdayKey);
          var eqamaNotificationValue = CacheHelper.getData(key: eqamaKey);
          var nightPrayerNotificationValue =
              CacheHelper.getData(key: nightPrayerKey);
          var dailyQuranNotificationValue =
              CacheHelper.getData(key: dailyQuranKey);
          var morningEveningNotificationValue =
              CacheHelper.getData(key: morningEveningKey);
          var approachingPrayersNotificationValue =
              CacheHelper.getData(key: approachingPrayersKey);

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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Transform.rotate(
                                    angle:
                                        cubit.isArabic() ? 180 * 3.14 / 180 : 0,
                                    child:
                                        SvgPicture.asset('images/Vector.svg'))),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                S
                                    .of(context)
                                    .Reminder_to_read_Surat_AlKahf_on_Friday,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
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
                                  value: surahElkahfNotificationValue ?? true,
                                  onChanged: (value) {
                                    cubit.setSurahElkahfNotification(value);
                                    CacheHelper.putData(
                                        key: surahElKahfKey, value: value);
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
                          width: MediaQuery.of(context).size.width * 0.9,
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
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                  value: joumaaHoursNotificationValue ?? true,
                                  onChanged: (value) {
                                    cubit.setJumaaHoursNotification(value);
                                    CacheHelper.putData(
                                        key: joumaaHoursKey, value: value);
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
                          width: 5,
                        ),
                        Text(
                          S
                              .of(context)
                              .Remembering_to_pray_in_the_last_hour_of_Friday,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
                            value: doaaLastHourNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setDoaaLastJoumaaHourNotification(value);
                              CacheHelper.putData(
                                  key: doaaLastHourKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            value: prayOnProphetNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setPrayOnProphetNotification(value);

                              CacheHelper.putData(
                                  key: prayOnProphetKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            value: duhaPrayerNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setDuhaPrayerNotification(value);

                              CacheHelper.putData(
                                  key: duhaPrayerKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                          S
                              .of(context)
                              .A_reminder_to_fast_on_Mondays_and_Thursdays,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.3,
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
                            value: mondayThursdayNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setMondayThursdayNotification(value);
                              CacheHelper.putData(
                                  key: mondayThursdayKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            value: nightPrayerNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setNightPrayerNotification(value);
                              CacheHelper.putData(
                                  key: nightPrayerKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            S
                                .of(context)
                                .Remembering_to_pray_between_the_call_to_prayer_and_the_iqama,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                            value: eqamaNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setEqamNotification(value);
                              CacheHelper.putData(key: eqamaKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            S
                                .of(context)
                                .Reminder_to_read_daily_roses_from_the_Holy_Quran,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                            value: dailyQuranNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setDailyQuran(value);
                              CacheHelper.putData(
                                  key: dailyQuranKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            S
                                .of(context)
                                .Remembering_the_morning_and_evening_remembrances,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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
                            value: morningEveningNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setMorningEveningNotification(value);

                              CacheHelper.putData(
                                  key: morningEveningKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            value: approachingPrayersNotificationValue ?? true,
                            onChanged: (value) {
                              cubit.setapproachingPrayersNotification(value);
                              CacheHelper.putData(
                                  key: approachingPrayersKey, value: value);
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
                    width: MediaQuery.of(context).size.width * 0.9,
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
