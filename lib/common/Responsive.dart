import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  const Responsive({super.key,required this.desktop,required this.mobile});

  static bool isMobile(BuildContext context){
    return MediaQuery.of(context).size.width < 850;
  }

  static bool isdesktop(BuildContext context){
    return MediaQuery.of(context).size.width >=1100;
  }
  @override
  Widget build(BuildContext context) {
   if(isdesktop(context)){
     return desktop;
   }else{
     return mobile;
   }
  }
}
