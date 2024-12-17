import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/Common color.dart';
import '../common/common Textstyle.dart';

AppBar common_appbar(String txt){
  return AppBar(
    // backgroundColor: Colors.grey.shade100,
    backgroundColor: Color_Constant.primarycolr,
    leading: IconButton(onPressed: (){
      Get.back();
    }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
    title: Text(txt,style: commonstyle(color: Colors.white,size: 18),),
    centerTitle: true,
  );
}