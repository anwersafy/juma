import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jumaa/component/string_manager.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

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
          'الشروط و الاحكام و سياسة الخصوصية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: MaterialButton(onPressed: (){
          Navigator.pop(context);
        },
            child:SvgPicture.asset('images/Vector.svg') ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all( 20),
            height: 500,
           width: double.infinity,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                cubit.isArabic()?box.read(privacyCollectionNameAr)?? '':
        box.read(privacyCollectionNameEn)??'',
                //  S.of(context).Terms_and_Conditions_and_Privacy_Policy,
                  style: TextStyle(

                    color: Colors.black,
                    fontSize: 18,

                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
           ),

           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('images/img_rectangle98.png'),
               fit: BoxFit.cover,
             ),
           ),
          )

        ],
      ),


    );
  }
    );
}

}
