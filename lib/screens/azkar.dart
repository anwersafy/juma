import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';
import 'azkar/azan_azkar.dart';
import 'azkar/fadl_tasbih_azkar.dart';
import 'azkar/morning_azkar.dart';
import 'azkar/night_azkar.dart';
import 'azkar/sleep_azkar.dart';
import 'azkar/after_pray.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
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
              S.of(context).The_remembrances_of_a_Muslim,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            leading: MaterialButton(
                onPressed: (){
              Navigator.pop(context);
            },
                child:SvgPicture.asset('images/Vector.svg') ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MorningAzkar()) ,);

                  } ,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                              S.of(context).The_morning_remembrances,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NightAzkar()) ,);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child:Text(
                              S.of(context).The_evening_remembrances,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AfterPray()) ,);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                              cubit.isArabic()?
                              'الاذكار بعد السلام من الصلاة':
                              'The remembrances after prayer',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FadlTasbihAzkar()) ,);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                              cubit.isArabic()?

                              'فضل التسبيح والتحميد والتكبير والتهليل':
                              'The virtue of glorification, praise ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AzanAzkar()) ,);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                              S.of(context).The_supplications_after_the_Adhan,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SleepAzkar()) ,);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 14.0, top: 14.0),
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text(
                             S.of(context).The_supplications_before_sleep,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                        ],
                      ),
                      width: 380,
                      height: 80,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Rectangle 108.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                        ],
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),


        );
      }
    );
  }
}
