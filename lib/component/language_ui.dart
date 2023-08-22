import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();

}

class _LanguageState extends State<Language> {
  String dropdownValue = 'English';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,) ,

        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Text('  اللغه',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansArabic',
            ),),
          ),
        ),
        SizedBox(height: 10,) ,
        Container(
          width: 200,
          child: ListTile(
            leading: Image.asset('images/internet.png',width: 30,height: 40,),
            title: DropdownButton<String>(
              icon: LineIcon.alternateArrowCircleDownAlt(),
              value: dropdownValue,
              onChanged: ( newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['English', 'العربيه']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );

  }
}
