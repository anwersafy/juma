import 'package:flutter/material.dart';

showAlertAdminDialog(BuildContext context,String message,String title) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title,style: TextStyle(
      color: Colors.black,
      // fontSize: 17,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',

    ),),
    content: Text(
      message,
      // cubit.isArabic()?box.read('adminMessageAr')??'':box.read('adminMessageEn')??'',
      style: TextStyle(
      color: Colors.black,
      // fontSize: 17,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cairo',

    ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}