import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DarkMode extends StatefulWidget {
  DarkMode({Key? key}) : super(key: key);

  @override
  State<DarkMode> createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  bool status = false;


  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,) ,
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Text('  الوضع الداكن',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansArabic',
            ),),
          ),
        ),
        SizedBox(height: 20,) ,
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Image.asset('images/dark-mode.png',width: 30,height: 40,),
              Text('تفعيل الوضع الداكن', maxLines : 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansArabic',

              ),),
              SizedBox(width: 30,) ,
              Switch(


                value: status,
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),


            ],
          ),
        ),
      ],
    );
  }
}
