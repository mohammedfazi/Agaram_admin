import 'package:flutter/material.dart';

import '../common/common Textstyle.dart';

void alertToastRed(BuildContext context, String txt) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 300, vertical: 30),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              txt,
              style: btntxtwhite),
          Icon(Icons.info,color: Colors.white,)
        ],
      ), // Customize as needed
    ),
  );
}


void alerttoastredgreen(BuildContext context,String txt){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          content: Text(txt,style: btntxtwhite,))
  );
}
