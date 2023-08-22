import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
   Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isSwitched = false;
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
            child: Text('  الإشعارات',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansArabic',
            ),),
          ),
        ),
        SizedBox(height: 10,) ,
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
             //  SizedBox(width: 30,) ,
                    Image.asset('images/notification.png',width: 30,height: 40,),
                    Text('تفعيل الإشعارات', maxLines : 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                    fontSize: 15,
                   fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansArabic',

                         ),),
               SizedBox(width: 30,) ,
               Switch(
                 value: isSwitched,
                 onChanged: (value) {
                    setState(() {
                      isSwitched = value;
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
