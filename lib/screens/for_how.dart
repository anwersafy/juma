import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';

import '../component/string_manager.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';

class ForHow extends StatelessWidget {
  const ForHow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var box = GetStorage();
        var cubit=AppCubit.get(context);
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
              'لمن اجر و ثواب هذا التطبيق',
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
                child:SvgPicture.asset('images/Vector.svg') ),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            height: 250,
            width: double.infinity,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/img_rectangle98.png'),
                fit: BoxFit.cover,
              ),
        ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
               cubit.isArabic()?box.read(forWhoCollectionNameAr)??
               "أشهدالله تعالى أن هذا التطبيق وقف عني وعن زوجتى وعن ذريتي وعن والدي ووالدتي ووالديهم وعن اخواني واخواتي وعن ولاة أمرنا وذرياتهم وعن علمائنا وذرياتهم وعن كل مسلم يستخدم هذا التطبيق وعن زوجته وذريته وعن كل موتى المسلمين"
               :box.read(forWhoCollectionNameEn)??'I testify that this application is a stop for me, my wife, my offspring, my parents, my parents, my brothers and sisters, our rulers and their offspring, our scholars and their offspring, and every Muslim who uses this application, his wife and his offspring, and all the dead Muslims',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
               //   fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),


          ),


        );
      }
    );
  }
}
