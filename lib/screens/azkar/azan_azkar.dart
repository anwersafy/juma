import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/l10n.dart';
import 'component.dart';

class AzanAzkar extends StatelessWidget {
  const AzanAzkar({super.key});

  @override
  Widget build(BuildContext context) {
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
            'اذكار  الاذان',
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

        body: ListView(
          children: [
            Component(text: '●	يقول مثل ما يقول المؤذن إلا في (حي على الصلاة وحي على الفلاح) فيقول: (لا حول ولا قوة إلا بالله).',),
            Component(text: '●	يقول: (وأنا أشهد أن لا إله إلا الله وحده لا شريك له وأن محمدا عبده ورسوله، رضيت بالله ربا، وبمحمد رسولا، وبالإسلام دينا) (يقول ذلك عقب تشهد المؤذن)',),
            Component(text: '●	(يصلي على النبي صلى الله عليه وسلم بعد فراغه من إجابة المؤذن)',),
            Component(text: '●	يقول: (اللهم رب هذه الدعوة التامة، والصلاة القائمة، آت محمدا الوسيلة والفضيلة، وابعثه مقاما محمودا الذي وعدته، [إنك لا تخلف الميعاد])',),
            Component(text: '●	(يدعو لنفسه بين الأذان والإقامة فإن الدعاء حينئذ لا يرد).',),






          ],
        )

    );
  }
}
