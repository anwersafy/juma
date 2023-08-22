import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/l10n.dart';
import 'component.dart';

class SleepAzkar extends StatelessWidget {
  const SleepAzkar({super.key});

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
            'اذكار  النوم',
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
            Component(text: '●	آية الكرسي(اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ مَن ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلاَ يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلاَّ بِمَا شَاء وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ وَلاَ يَؤُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ). [آية الكرسي – البقرة 255]. مرة واحدة (1).',),
            Component(text: '●	آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ كُلٌّ آمَنَ بِاللَّهِ وَمَلائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ وَقَالُوا سَمِعْنَا وَأَطَعْنَا غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ (285)لا يُكَلِّفُ اللَّهُ نَفْساً إِلاَّ وُسْعَهَا لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ رَبَّنَا لا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا رَبَّنَا وَلا تَحْمِلْ عَلَيْنَا إِصْراً كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا رَبَّنَا وَلا تُحَمِّلْنَا مَا لا طَاقَةَ لَنَا بِهِ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا أَنْتَ مَوْلانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ (286)مرة واحدة (1)',),
            Component(text: '●	(يجمع كفيه ثم ينفث فيهما فيقرأ فيهما:بسم الله الرحمن الرحيم ﴿قل هو الله أحد * الله الصمد* لم يلد ولم يولد* ولم يكن له كفوا أحد﴾.',),
            Component(text: '●	بسم الله الرحمن الرحيم ﴿قل أعوذ برب الفلق* من شر ما خلق* ومن شر غاسق إذا وقب* ومن شر النفاثات في العقد* ومن شر حاسد إذا حسد﴾. ',),
            Component(text: '●	بسم الله الرحمن الرحيم ﴿قل أعوذ برب الناس* ملك الناس* إله الناس* من شر الوسواس الخناس* الذي يوسوس في صدور الناس* من الجنة و الناس﴾      (ثم يمسح بهما ما استطاع من جسده يبدأ بهما على رأسه ووجهه وما أقبل من جسده).',),
            Component(text: '●	(إذا قام أحدكم من فراشه ثم رجع إليه فلينفضه بصَنِفَةِ إزاره ثلاث مرات، وليُسمِّ اللَّه؛ فإنه لا يدري ما خلفه عليه بعده، وإذا اضطجع فليقل : باسمك ربي وضعت جنبي، وبك أرفعه، فإن أمسكت نفسي فارحمها، وإن أرسلتها فاحفظها، بما تحفظ به عبادك الصالحين).',),
            Component(text: '●	(اللهم إنك خلقت نفسي وأنت توفاها، لك مماتها ومحياها، إن أحييتها فاحفظها، وإن أمتها فاغفر لها. اللهم  إني أسألك العافية).',),
            Component(text: '●	كان صلى الله عليه وسلم إذا أراد أن يرقد وضع يده اليمنى تحت خدِّه، ثم يقول(اللهم قني عذابك يوم تبعث عبادك).',),
            Component(text: '●	(اللهم رب السموات السبع ورب الأرض، ورب العرش العظيم، ربنا ورب كل شيء، فالق الحب والنوى، ومنزل التوراة والإنجيل، والفرقان، أعوذ بك من شر كل شيء أنت آخذ بناصيته. اللهم أنت الأول فليس قبلك شيء، وأنت الآخر فليس بعدك شيء، وأنت الظاهر فليس فوقك شيء، وأنت الباطن فليس دونك شيء، اقض عنا الدين وأغننا من الفقر).',),
            Component(text: '●	(إذا أخذت مضجعك فتوضأ وضوءك للصلاة، ثم اضطجع على شقك الأيمن، ثم قل:اللهم أسلمت نفسي إليك، وفوضت أمري إليك، ووجهت وجهي إليك، وألجأت ظهري إليك، رغبة ورهبة إليك، لا ملجأ ولا منجا منك إلا إليك، آمنت بكتابك الذي أنزلت، وبنبيك الذي أرسلت).',),
            Component(text: '●	(اللهم عالم الغيب والشهادة فاطر السموات والأرض، رب كل شيء ومليكه، أشهد أن لا إله إلا أنت، أعوذ بك من شر نفسي، ومن شر الشيطان وشركه، وأن أقترف على  نفسي سوءا، أو أجره إلى مسلم).',),






          ],
        )

    );
  }
}
