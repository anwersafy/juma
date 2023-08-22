import 'package:flutter/material.dart';

class PageItem extends StatelessWidget {
  final pageNumber;
  const PageItem({Key? key, this.pageNumber}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('assets/quran/$pageNumber.png'),fit: BoxFit.fill,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height-105,

    );
    //   Stack(
    //   children: [
    //
    //     Image(image: AssetImage('assets/quran_page.png'),fit: BoxFit.fill,),
    //     Center(
    //       child: Text(
    //         pageItemStr,
    //         style: TextStyle(
    //           color: Colors.black,
    //           fontSize: 16,
    //           fontFamily: 'Cairo',
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
