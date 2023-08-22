import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jumaa/component/string_manager.dart';
import 'package:line_icons/line_icon.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';

class ToDoInJuma extends StatefulWidget {
  const ToDoInJuma({Key? key}) : super(key: key);

  @override
  State<ToDoInJuma> createState() => _ToDoInJumaState();
}

class _ToDoInJumaState extends State<ToDoInJuma> {
  @override
  void initState() {
    // TODO: implement initState
    InternetConnectionChecker().hasConnection.then((value) {
      if (value == true) {
        // AppCubit(). getCurrentPosition(context);
        // AppCubit(). azanNotification();
        // turnOnAllNotification();
        AppCubit().getAllFromFirebase();
      } else {
        AppCubit().scaffoldKey.currentState!..showSnackBar(
          SnackBar(
            content: Text(
                S.of(context).noInternet
            ),

            backgroundColor:  Color(0xFF57A7A2),
          ),
        );
      }

      super.initState();
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
        var box=GetStorage();
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                 //   Text(
                 //     'خير يوم طلعت عليه الشمس',
                 //     style: TextStyle(
                 //       color: Colors.black,
                 //       fontSize: 16,
                 //       fontFamily: 'Cairo',
                 //       fontWeight: FontWeight.w700,
                 //     ),
                 //   ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            cubit.isArabic()? box.read(jumaaSuinnCollectiionAr1)??'':box.read(jumaaSuinnCollectiionEn1)??'',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              //fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
                  width: double.infinity,
                  height:250,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img_rectangle77.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.02),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 13.15,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
                Container(

                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          cubit.isArabic()? box.read(jumaaSuinnCollectiionAr2)??'':box.read(jumaaSuinnCollectiionEn2)??'',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img_rectangle77.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.02),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 13.15,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
                Container(

                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          cubit.isArabic()? box.read(jumaaSuinnCollectiionAr3)??'':box.read(jumaaSuinnCollectiionEn3)??'',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                           // fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img_rectangle77.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.02),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 13.15,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
                // Container(
                //   child: ListView(
                //     children: [
                //      // Text(
                //      //  'ثواب قراءة سورة الاحقاف في كل جمعة',
                //      //  style: TextStyle(
                //      //    color: Colors.black,
                //      //    fontSize: 16,
                //      //    fontFamily: 'Cairo',
                //      //    fontWeight: FontWeight.w700,
                //      //  ),
                //      //),
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.01,
                //
                //       ),
                //       SizedBox(
                //         child: Center(
                //           child: Text(
                //             box.read('joumaaSunnin3')??
                //             'عن الامام جعفر بن محمد الصادق عليه السلام أنَّهُ قال: "مَنْ قَرَأَ كُلَّ جُمُعَةٍ سُورَةَ الْأَحْقَافِ لَمْ يُصِبْهُ اللَّهُ عَزَّ وَ جَلَّ بِرَوْعَةٍ فِي الدُّنْيَا وَ آمَنَهُ مِنْ فَزَعِ يَوْمِ الْقِيَامَةِ"',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 14,
                //               fontFamily: 'Cairo',
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ),
                //       )
                //
                //     ],
                //   ),
                //   margin: const EdgeInsets.only(top: 30, left: 8, right: 8),
                //   width: double.infinity,
                //   height: 250,
                //   decoration: ShapeDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('images/img_rectangle77.png'),
                //       fit: BoxFit.fill,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(7.02),
                //     ),
                //     shadows: [
                //       BoxShadow(
                //         color: Color(0x26000000),
                //         blurRadius: 13.15,
                //         offset: Offset(0, 0),
                //         spreadRadius: 0,
                //       )
                //     ],
                //   ),
                // ),


              ],
            )
          ),
        );
      }
    );
  }
}
