
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jumaa/cubit/cubit.dart';
import 'package:jumaa/service/radio_service.dart';

import '../cubit/states.dart';
import '../generated/l10n.dart';

class RadioScreen extends StatefulWidget {
   RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  @override
  void initState() {
    super.initState();
      !AppCubit.get(context).isPlaying?
      AppCubit.get(context).play():null;


  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
        AppCubit.get(context).radioStations=getRadioStations(AppCubit().arabicRadio);

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
              S.of(context).Radio_Holy_Quran,
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
                child:Transform.rotate(angle:!cubit.isArabic()? 180 * 3.14 / 180:0,
                    child: SvgPicture.asset('images/Vector.svg')) ),

          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width /3,
                    height: 123,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img_soundwave5.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width /3,
                    height: 107,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img_broadcast13.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width /3,
                    height: 123,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img_soundwave5.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                ],
              ),

              FutureBuilder(
              future: AppCubit.get(context).radioStations,
              builder: (context, stations) {
                if (stations.hasData) {
                  return GestureDetector(
                    onTap: () {
                      cubit.isPlaying ?
                      cubit.radioPlayer.pause()
                          : cubit.radioPlayer.play();
                    },
                    child: Container(
                      child:
                     cubit.isPlaying?
                      Image.asset('images/pause.png',
                        color:Color(0xFF87CBB9)):
                      Image.asset('images/play.png',
                        color: Color(0xFF87CBB9)

                      ),
                      width: 58,
                      height: 58,
                      padding:cubit.isPlaying? EdgeInsets.all(20):EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 0.50,
                            color: Colors.black.withOpacity(0.1899999976158142),
                          ),
                        ),
                      ),
                    ),
                  );
                }
        else if (stations.hasError) {
        return const CircularProgressIndicator(
          color: Colors.cyan,

        );
        }

        return CircularProgressIndicator(
          color: Colors.green,
        );
        },


              )
            ],
          ),


        );
      }
    );
  }
}
