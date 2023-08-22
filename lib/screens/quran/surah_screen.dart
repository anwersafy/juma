import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jumaa/screens/quran/page_widget.dart';
import 'package:quran/quran.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class SurahScreen extends StatefulWidget {
  final int surahNumber;
  final int? lastReadPage;
  final int? lastReadAyah;

  const SurahScreen(this.surahNumber, {Key? key, this.lastReadPage, this.lastReadAyah}) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}



class _SurahScreenState extends State<SurahScreen> {
  var _pdfViewerController = PdfViewerController();
  @override
  initState() {




    _pdfViewerController.jumpToPage(getSurahPages(widget.surahNumber)[0]);


    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
     listener: (context, state) {},
      builder: (context,state) {
        var cubit = AppCubit.get(context);
        var verseLength = getVerseCount(widget.surahNumber);
        var surahName = getSurahName(widget.surahNumber);

        var surahNameArabic = getSurahNameArabic(widget.surahNumber);

        var surahPage = getSurahPages(widget.surahNumber);

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
              'سورة ${getSurahNameArabic(widget.surahNumber)}',
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),),
            centerTitle: true,
            elevation: 0,
            leading: MaterialButton(onPressed: (){
              Navigator.pop(context);
            },
                child:Transform.rotate(angle:180 * 3.14 / 180,
                    child: SvgPicture.asset('images/Vector.svg')) ),

          ),
          body: SfPdfViewer.asset(
            'assets/pdf/quranP.pdf',
            controller: _pdfViewerController,
          )
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListView.builder(
          //     itemCount: surahPage.length,
          //     itemBuilder: (context, index) {
          //       var verse=getVerse(surahNumber, index+1);
          //       var pages=getVersesTextByPage(surahNumber,
          //       verseEndSymbol: true,
          //       surahSeperator: SurahSeperator.surahNameArabic,
          //       );
          //       return Expanded(
          //         child: Column(
          //           children: [
          //             PageItem(
          //              pageNumber: surahPage[index],
          //             ),
          //             SizedBox(height: 15,),
          //           ],
          //         ),
          //       );
          //
          //
          //     },
          //   ),
          // ),
          );
      }


    );
  }
}