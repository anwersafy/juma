import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:line_icons/line_icon.dart';

import '../component/string_manager.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';

class EarlyPray extends StatelessWidget {
  const EarlyPray({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var box = GetStorage();

          return Scaffold(
            body: ListView(
              children: [
                SizedBox(height: 6.h),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    //height: MediaQuery.of(context).size.height*0.3,
                    height: 250.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img_rectangle98.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height*0.3,
                            height: 250.h,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                    child: Text(
                                      cubit.isArabic()
                                          ? box.read(jumaaHadithCollectionAr) ??
                                          'قال عليه الصلاة والسلام في حديث آخر: «إذا كان يوم الجمعة كان على كل باب من أبواب المسجد ملائكة يكتبون الأول فالأول، فإذا جلس الإمام طووا الصحف وجاؤوا يستمعون الذكر».'
                                          : box.read(jumaaHadithCollectionEn) ??
                                          'قال عليه الصلاة والسلام في حديث آخر: «إذا كان يوم الجمعة كان على كل باب من أبواب المسجد ملائكة يكتبون الأول فالأول، فإذا جلس الإمام طووا الصحف وجاؤوا يستمعون الذكر».',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: ShapeDecoration(
                          color: Color(0xFF577D86),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).First_Hour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  S.of(context).Like_donating_a_camel,
                                  style: TextStyle(
                                    color: Colors.white,
                                    //  fontSize: MediaQuery.of(context).size.width*0.03,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('StartprayerHour0') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.023,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.023,
                                    ),
                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour0') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                                width:
                                MediaQuery.of(context).size.width * 0.05),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: ShapeDecoration(
                          color: Color(0xFF569DAA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).Second_Hour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  S.of(context).Like_donating_a_cow,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour0') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.023,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.023),
                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour1') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                                width:
                                MediaQuery.of(context).size.width * 0.05),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: ShapeDecoration(
                          color: Color(0xFF87CBB9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).Third_Hour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  S.of(context).like_donating_a_horned_ram,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour1') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.023,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour2') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                                width:
                                MediaQuery.of(context).size.width * 0.04),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: ShapeDecoration(
                          color: Color(0xFF577D86),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).Fourth_Hour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  S.of(context).Like_donating_a_chicken,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour2') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.023,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour3') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: ShapeDecoration(
                          color: Color(0xFF569DAA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).Fifth_Hour,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  S.of(context).Like_donating_an_egg,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('EndprayerHour3') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Column(children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  box.read('dhuhr') ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(
                                width:
                                MediaQuery.of(context).size.width * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

