
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../common/common Size.dart';
import '../common/common Textstyle.dart';

Widget common_button(String txt,routescreen, {Color color = Colors.orange}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Builder(
      builder: (context) {
        return SizedBox(
          height: displayheight(context)*0.06,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
              onPressed: (){
            Navigator.push(context, PageTransition(
                child: routescreen,
                ctx: context,
                inheritTheme: true,
                type: PageTransitionType.fade));
          },
              child: Center(child: Text("$txt",style: btntxtwhite,))),
        );
      }
    ),
  );
}