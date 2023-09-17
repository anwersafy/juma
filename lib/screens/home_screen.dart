import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../component/string_manager.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {






  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          final box = GetStorage();
          var imagesAr = box.read(keyLinksAr)??[];
          var imagesEn = box.read(keyLinksEn)??[];
          String locale = Localizations.localeOf(context).languageCode;
          DateTime now = new DateTime.now();
          // String dayMonth = intl.DateFormat.MMMMd(locale).format(now);
          // String year = intl.DateFormat.y(locale).format(now);
          String dayOfWeek = intl.DateFormat.EEEE(locale).format(now);
          String dayMonth = intl.DateFormat.MMMMd(locale).format(now);
          //  String dayMonth = intl.DateFormat.MMMMd(locale).format(now);
          String year = intl.DateFormat.y(locale).format(now);
          var hijriDate =  HijriCalendar.now();
          String hijriDayMonth = hijriDate.toFormat("dd MMMM");
          String hijriYear = hijriDate.toFormat("yyyy");
          String hijriDayOfWeek = hijriDate.toFormat("EEEE");
          HijriCalendar.setLocal(locale);






          return Scaffold(
            body:
            box.read('addressAr') == null? Center(child: CircularProgressIndicator(),) :
            SingleChildScrollView(
              child: Column(
                children: [
                  ImageSlideshow(
                      autoPlayInterval: 5000,
                      isLoop: true,

                      height: 350.h, children:
                  cubit.isArabic()?
                  List.generate(imagesAr.length+1, (index) {
                    if (index==0)
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 550,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/img_rectangle1.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).Application,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).Jummah,
                                      style: TextStyle(
                                        color: Color(0xFF569DAA),
                                        fontSize: 28,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     IconButton(
                                //         onPressed: ()async {
                                //           final urlImage =
                                //           cubit.isArabic()?
                                //           box.read('imageAr'):box.read('imageEn')??
                                //               'https://rwad360.com/wp-content/uploads/2020/01/34499484_1390368081108035_2740735424623280128_n.jpg';
                                //           final url = Uri.parse(urlImage);
                                //           final response = await get(url);
                                //           final bytes = response.bodyBytes;
                                //           final temp = await getTemporaryDirectory();
                                //           final path = '${temp.path}/image.jpg';
                                //
                                //           File(path).writeAsBytesSync(bytes);
                                //           await Share.shareFiles([path]);
                                //
                                //         },
                                //         icon: SvgPicture.asset(
                                //             'images/img_share.svg')),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    else
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            height: 550,
                            decoration: const BoxDecoration(

                                color: Color(0xFF569DAA),
                                borderRadius:
                                BorderRadius.all(Radius.circular(19))),
                            child:Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children:[
                                  Center(child: Image.network(imagesAr[index-1],fit: BoxFit.cover,width: double.infinity,height: double.infinity,),),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: ()async {
                                            final urlImage = imagesAr[index-1];
                                            final url = Uri.parse(urlImage);
                                            final response = await get(url);
                                            final bytes = response.bodyBytes;
                                            final temp = await getTemporaryDirectory();
                                            final path = '${temp.path}/image.jpg';

                                            File(path).writeAsBytesSync(bytes);
                                            await Share.shareFiles([path]);

                                          },
                                          icon: SvgPicture.asset(
                                              'images/img_share.svg')),
                                    ],
                                  )

                                ]
                            )

                        ),
                      );
                  })
                      :
                  List.generate(imagesEn.length+1, (index) {
                    if (index==0)
                      return  Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 550.h,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/img_rectangle1.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).Application,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).Jummah,
                                      style: TextStyle(
                                        color: Color(0xFF569DAA),
                                        fontSize: 28.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     IconButton(
                                //         onPressed: ()async {
                                //           final urlImage =
                                //           cubit.isArabic()?
                                //           box.read('imageAr'):box.read('imageEn')??
                                //               'https://rwad360.com/wp-content/uploads/2020/01/34499484_1390368081108035_2740735424623280128_n.jpg';
                                //           final url = Uri.parse(urlImage);
                                //           final response = await get(url);
                                //           final bytes = response.bodyBytes;
                                //           final temp = await getTemporaryDirectory();
                                //           final path = '${temp.path}/image.jpg';
                                //
                                //           File(path).writeAsBytesSync(bytes);
                                //           await Share.shareFiles([path]);
                                //
                                //         },
                                //         icon: SvgPicture.asset(
                                //             'images/img_share.svg')),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    else
                      return
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              height: 550.h,
                              decoration: const BoxDecoration(

                                  color: Colors.transparent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(19))),
                              child:Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children:[
                                    Center(child: Image.network(imagesEn[index-1],fit: BoxFit.cover,width: double.infinity,height: double.infinity,)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: ()async {
                                              final urlImage = imagesEn[index-1];
                                              final url = Uri.parse(urlImage);
                                              final response = await get(url);
                                              final bytes = response.bodyBytes;
                                              final temp = await getTemporaryDirectory();
                                              final path = '${temp.path}/image.jpg';

                                              File(path).writeAsBytesSync(bytes);
                                              await Share.shareFiles([path]);

                                            },
                                            icon: SvgPicture.asset(
                                                'images/img_share.svg')),
                                      ],
                                    )

                                  ]
                              )

                          ),
                        );

                  })



                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                  AssetImage('images/img_rectangle55.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              S.of(context).Prayer_Timings,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              // '17 ذو القعدة 1444 ه /',
                              ' $hijriDayMonth '+ '$hijriYear '+'  /  ',
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.4000000059604645),
                                fontSize: MediaQuery.of(context).size.width *
                                    0.035,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            //'06 جوان 2023م',
                            '$dayMonth $year',

                            style: TextStyle(
                              color:
                              Colors.black.withOpacity(0.4000000059604645),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.035,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,

                            ),
                          ),
                          SizedBox(width: 35.w,),
                          Text(
                            //'06 جوان 2023م',
                            '$dayOfWeek',

                            style: TextStyle(
                              color:
                              Colors.black.withOpacity(0.4000000059604645),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.035,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,

                            ),
                          ),
                        ],
                      ),
                      prayerItem( cubit: cubit,
                      timePrayer: box.read('fajr'),prayerName: S.of(context).Fajr,
                      image: 'images/img_rectangle56.png',
                      ),
                      prayerItem(cubit: cubit,
                        timePrayer: box.read('sunrise'),prayerName: S.of(context).Sunrise,
                      image: 'images/img_rectangle62.png',
                      ),
                      prayerItem( cubit: cubit,
                        timePrayer: box.read('dhuhr'),prayerName: S.of(context).Zuhr,
                      image: 'images/img_rectangle67.png',
                      ),

                      prayerItem( cubit: cubit,
                        timePrayer: box.read('asr'),prayerName: S.of(context).Asr,
                      image: 'images/Rectangle 72.png',
                      ),

                      prayerItem( cubit: cubit,
                        timePrayer: box.read('maghrib'),prayerName: S.of(context).Maghreb,
                      image: 'images/img_rectangle62.png',
                      ),
                      prayerItem( cubit: cubit,
                        timePrayer: box.read('isha'),prayerName: S.of(context).Isha,
                      image: 'images/img_rectangle56.png',
                      ),



                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class prayerItem extends StatelessWidget {
  const prayerItem({
    super.key,

    required this.cubit,

    required this.timePrayer,
    required this.prayerName,
    required this.image,
  });


  final AppCubit cubit;
  final String timePrayer;
  final String prayerName;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 13.w,
          ),
          Container(
            width:17.w,
            height: 17.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            prayerName??'',
            style: TextStyle(
              color: Colors.black,
              fontSize:14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            width:15.w,
          ),
          Text(
            timePrayer??'',
            style: TextStyle(
              color: Color(0xFF87CBB9),
              fontSize: 17.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
         SizedBox(
           width: 20.w,
         ),
          Text(
            cubit.isArabic()?'المتبقي':'remaining',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Spacer(),
          Container(
              child: SlideCountdownSeparated(
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  color: Color(0xFF87CBB9),
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold
                ),
                textDirection: cubit.isArabic()
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                duration: cubit.getLeftTime(
                  timePrayer??'00:00',),
              )),
          SizedBox(
            width:12.w
          ),
        ],
      ),
      width:double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
    );
  }
}
