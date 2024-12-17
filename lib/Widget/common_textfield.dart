import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/common Textstyle.dart';

Widget commontextfield(txt,controller, {int lines = 1,bool static=true}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      style: commonstyle(size: 15,color: Colors.black,weight: FontWeight.w500),
      cursorColor: Colors.black,
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)
        ),
          focusedBorder:const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)
          ),
        fillColor: Colors.grey.shade400,
        filled: true,
        enabled:static,
        hintText: txt,
        hintStyle: commonstyle()
      ),
    ),
  );
}