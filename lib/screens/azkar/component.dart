import 'package:flutter/cupertino.dart';

class Component extends StatelessWidget {
  const Component({super.key,required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Text(

              text,
              textAlign: TextAlign.center,
              style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              //fontFamily: 'Cairo',
            ),),
          ),
        ),
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/img_rectangle98.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
