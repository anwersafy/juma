import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jumaa/component/string_manager.dart';
import 'package:line_icons/line_icon.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';

class NightPray extends StatefulWidget {
  const NightPray({Key? key}) : super(key: key);

  @override
  State<NightPray> createState() => _NightPrayState();
}

class _NightPrayState extends State<NightPray> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                S.of(context).noInternet
            ),
            backgroundColor:   Color(0xFF57A7A2),
          ),
        );
      }

      super.initState();
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
        var box =GetStorage();
        return Scaffold(
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


            title: Text(
             S.of(context).Night_Prayer
              ,style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),),
            centerTitle: true,
            elevation: 0,
            leading: MaterialButton(onPressed: (){
              Navigator.pop(context);
            },
                child:Transform.rotate(angle:!cubit.isArabic()? 180 * 3.14 / 180:0,
                    child: SvgPicture.asset('images/Vector.svg')) ),

          ),
          body:ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                         cubit. isArabic()? box.read(nightHadithCollectionAr)??'':box.read(nightHadithCollectionEn)??''
                          ,style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,

                        ),
                          textAlign: TextAlign.center,

                        ),
                      ),
                    ),

                  ),
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/img_rectangle98.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  height:MediaQuery.of(context).size.height*0.1,
                  decoration: ShapeDecoration(
                    color: Color(0xFF577D86),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),

                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:13),
                      Text(
                      S.of(context).The_first_part_of_the_night,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(

                              children:[
                                Row(
                                  children: [
                                    SizedBox(width:
                                    MediaQuery.of(context).size.width*0.02,),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  box.read('StartNightThirds1')??'',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: MediaQuery.of(context).textScaleFactor*14 ,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ]

                          ),
                        ),
                      ),
                      SizedBox(width: 4),

                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(

                              children:[
                                Row(
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),

                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  box.read('EndNightThirds1')??'',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 12,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ]

                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  height:MediaQuery.of(context).size.height*0.1,
                  decoration: ShapeDecoration(
                    color: Color(0xFF569DAA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),

                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:13),
                      Text(
                        S.of(context).The_second_part_of_the_night,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(

                              children:[
                                Row(
                                  children: [
                                    SizedBox(width:
                                    MediaQuery.of(context).size.width*0.02,),
                                    Text(
                                      S.of(context).from,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  box.read('EndNightThirds1')??'',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ]

                          ),
                        ),
                      ),
                      SizedBox(width: 4),

                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(

                              children:[
                                Row(
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),

                                    Text(
                                      S.of(context).to,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  box.read('EndNightThirds2')??'',
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ]

                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.1,
                  decoration: ShapeDecoration(
                    color: Color(0xFF87CBB9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),

                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:18),
                      Text(
                        S.of(context).The_third_part_of_the_night,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(

                            children:[
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                  Text(
                                    S.of(context).from,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                box.read('EndNightThirds2')??'',
                                style: TextStyle(
                                  color: Color(0xFF959595),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ]

                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.23,
                        height: MediaQuery.of(context).size.height*0.08,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(

                            children:[
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                  Text(
                                    S.of(context).to,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                box.read('EndNightThirds3')??'',
                                style: TextStyle(
                                  color: Color(0xFF959595),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ]

                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                    ],
                  ),
                ),
              ),




            ],
          ),



        );
      }
    );
  }
}
