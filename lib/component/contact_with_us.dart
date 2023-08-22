import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWithUs extends StatefulWidget {
  ContactWithUs({Key? key}) : super(key: key);

  @override
  State<ContactWithUs> createState() => _ContactWithUsState();
}

class _ContactWithUsState extends State<ContactWithUs> {
  Uri face = Uri.parse('https://twitter.com/anwersafyy');
  Uri khamsat = Uri.parse('https://mail.google.com/mail/u/0/#inbox');


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Text(' تواصل معنا', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansArabic',
            ),),
          ),
        ),
        SizedBox(height: 20,),
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                launchUrl(face);


                           }

              ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'images/twitter-sign.png', width: 50, height: 40,),
                  Text(' عبر تويتر', maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansArabic',

                    ),),
                  SizedBox(width: 30,),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Divider(height: 20, color: Colors.grey[300], thickness: 1,),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
               launchUrl(khamsat);
                   },


              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('images/email (1).png', width: 50, height: 40,),
                  Text(' عبر البريد', maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansArabic',

                    ),),
                  SizedBox(width: 30,),
                ],
              ),
            ),

          ],
        )

      ],
    );
  }
}
