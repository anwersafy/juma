import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jumaa/component/string_manager.dart';
import 'package:jumaa/screens/privacy.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../generated/l10n.dart';
import 'for_how.dart';
import 'notification.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {},
        builder: (context,state) {
          var box = GetStorage();
          var email = box.read(contactUsCollectionName);
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),

                          Text(
                            S.of(context).Settings,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).textScaleFactor * 22,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForHow()));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                              ),
                              Text(
                                S.of(context).For_who_is_the_reward_for_this_application,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width:24,
                                height: MediaQuery.of(context).size.height * 0.03,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForHow()));
                                    },
                                    child: SvgPicture.asset(('images/ep_arrow-left-bold.svg'))),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width*0.9,
                          margin: EdgeInsets.all( 10),
                          height: MediaQuery.of(context).size.height * 0.077,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.26,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF87CBB9), Color(0xFF569DAA)],
                    ),
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SvgPicture.asset(('images/clarity_language-solid.svg')),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),

                      Text(
                        S.of(context).Language,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      DropdownButton(
                        icon: SvgPicture.asset(('images/Vector (1).svg')),
                        value:  cubit.language,
                        onChanged: ( newValue) {
                          cubit.changeLanguage(newValue);

                        },
                        items: <String>['English', 'العربيه']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),

                    ],
                  ),
                  width:MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.all( 10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreeen()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        SvgPicture.asset(('images/mingcute_notification-fill.svg')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),

                        Text(
                          S.of(context).Notics,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.03,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreeen()));
                              },
                              child: SvgPicture.asset(('images/ep_arrow-left-bold.svg'))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all( 10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Privacy()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        SvgPicture.asset(('images/dashicons_privacy.svg')),
                        SizedBox(
                          width: 2,
                        ),

                        Text(
                          S.of(context).Terms_and_Conditions_and_Privacy_Policy,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.03,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Privacy()));
                              },
                              child: SvgPicture.asset(('images/ep_arrow-left-bold.svg')
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.0001,
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: EdgeInsets.all( 10),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                       cubit.isArabic()?
                           'تواصل معنا عبر البريد الالكتروني التالي':
                        'Contact us via the following email'
                        ,style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          launch('mailto:${email??'sulaimanmf@gmail.com'}?subject=This is Subject Title&body=This is Body of Email');
                        },
                        child: Text(
                          email??'sulaimanmf@gmail.com',
                          style: TextStyle(
                            color: Color(0xFF87CBB9),
                            fontSize: MediaQuery.of(context).textScaleFactor * 16,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).Post_the_link_of_this_application_via_social_media,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){}, icon: SvgPicture.asset(('images/img_fileiconstelegram.svg'))),
                          IconButton(onPressed: (){}, icon: SvgPicture.asset(('images/ph_instagram-logo-fill.svg'))),
                          IconButton(onPressed: (){}, icon: SvgPicture.asset(('images/img_mditwitter.svg'))),
                          IconButton(onPressed: (){}, icon: SvgPicture.asset(('images/img_mdifacebook.svg'))),
                        ],
                      ),
                    ],
                  ),
                )





              ],
            ),

          );
        }
    );
  }
}
