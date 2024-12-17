import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StackDialog{
  static Future show(String header,String body,IconData? icon,Color color)async{
    return Get.snackbar(
        margin:const EdgeInsets.only(top:10.0,left: 8.0,right: 8.0),
        backgroundColor: Colors.white,
        maxWidth:400,
        header,
        body,
        icon: Icon(icon!,color: color,size: 30,),
        duration:const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP
    );
  }
}