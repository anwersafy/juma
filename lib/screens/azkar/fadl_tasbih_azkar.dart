import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/l10n.dart';
import 'component.dart';

class FadlTasbihAzkar extends StatelessWidget {
  const FadlTasbihAzkar({super.key});

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
            ' فضل التسبيح والتحميد والتهليل والتكبير',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
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
            Component(text: '●	(قال صلى الله عليه وسلم من قال: سبحان الله وبحمده في يوم مائة مرة حطت خطاياه ولو كانت مثل زبد البحر). ',),
            Component(text: '●	قال صلى الله عليه وسلم: (من قال لا إله إلا الله وحده لا شريك له، له الملك، وله الحمد، وهو على كل شيء قدير عشر مرار، كان كمن أعتق أربعة أنفس من ولد إسماعيل). ',),
            Component(text: '●	قال صلى الله عليه وسلم: (كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم). ',),
            Component(text: '●	وقال صلى الله عليه وسلم: (لأن أقول سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر، أحب إلي مما طلعت عليه الشمس). ',),
            Component(text: '●	قال صلى الله عليه وسلم: (أيعجز أحدكم أن يكسب كل يوم ألف حسنة) فسأله سائل من جلسائه كيف يكسب أحدنا ألف حسنة؟ قال: (يسبح مائة تسبيحة، فيكتب له ألف حسنة أو يحط عنه ألف خطيئة). ',),
            Component(text: '●	(من قال: سبحان الله العظيم وبحمده غرست له نخلة في الجنة). ',),
            Component(text: '●	قال صلى الله عليه وسلم: (يا عبد الله بن قيس ألا أدلك على كنز من كنوز الجنة)؟ فقلت: بلى يا رسول الله، قال: (قل لا حول ولا قوة إلا بالله). ',),
            Component(text: '●	قال صلى الله عليه وسلم: (أحب الكلام إلى الله أربع: سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر، لا يضرك بأيهن بدأت) ',),
            Component(text: '●	جاء أعرابي إلى رسول الله صلى الله عليه وسلم فقال: علمني كلاما أقوله: قال: (قل: لا إله إلا الله وحده لا شريك له، الله أكبر كبيرا، والحمد لله كثيرا، سبحان الله رب العالمين، لا حول ولا قوة إلا بالله العزيز الحكيم) قال: فهؤلاء لربي، فما لي؟ قال: (قل: اللهم اغفر لي، وارحمني، واهدني، وارزقني). ',),
            Component(text: '●	كان الرجل إذا أسلم علمه النبي صلى الله عليه وسلم الصلاة ثم أمره أن يدعو بهؤلاء الكلمات: (اللهم اغفر لي، وارحمني، واهدني، وعافني وارزقني). ',),
            Component(text: '●	قال صلى الله عليه وسلم (إن أفضل الدعاء الحمد لله، وأفضل الذكر لا إله إلا الله). ',),
            Component(text: '●	(الباقيات الصالحات: سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر، ولا حول ولا قوة إلا بالله). ',),






          ],
        )

    );
  }
}
