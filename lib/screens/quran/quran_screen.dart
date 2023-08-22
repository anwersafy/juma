import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jumaa/cubit/cubit.dart';
import 'package:jumaa/screens/quran/surah_screen.dart';
import 'package:quran/quran.dart';

import '../../cubit/states.dart';
import '../../generated/l10n.dart';

class HolyQuran extends StatelessWidget {
  const HolyQuran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
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
                S.of(context).The_Holy_Quran,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              leading: MaterialButton(onPressed: (){
                Navigator.pop(context);
              },
                  child:Transform.rotate(angle:!cubit.isArabic()? 180 * 3.14 / 180:180 * 3.14 / 180,
                      child: SvgPicture.asset('images/Vector.svg')) ),

            ),
            body: ListView.builder(
              itemBuilder:(context,index){
                return
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahScreen(
                               index+1,

                            ),
                          )
                        );

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [

                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset(
                                  "images/img_ellipse19.png",
                                  width: 40,
                                  height:40,
                                ),

                               Text(
                                 '${index+1}',
                                 style: TextStyle(
                                   fontSize: 18,
                                   fontFamily: 'Cairo',
                                   fontWeight: FontWeight.w600,
                                 ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  "سورة ${getSurahNameArabic(index + 1)}  ",

                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'عدد الآيات: ${getVerseCount(index+1)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${getPlaceOfRevelation(index+1)=='Makkah'?'مكية':'مدنية'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),


                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    );


              },
              itemCount: 114,

            ),

          ),
        );
      }
    );
  }
}
