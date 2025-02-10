import 'dart:convert';
import 'package:agaram_admin/Config.dart';
import 'package:agaram_admin/Screens/Dashboard/Dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/Toast_dialog.dart';


class OtpController extends GetConnect{

  String?service;
  Future<dynamic> OtpApi(BuildContext context,number,otp)async{

    service=Config.LOGIN_API;

    final url=Uri.parse("${service}auth/otpValidated");

    final header=Config.Header;

    final json='{"phone":"$number","roleId":"1","otp":"$otp"}';

    final responce=await http.post(url,headers: header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("session","1");
      prefs.setString("token", data['token']??"");
      print("Token : $data['token']");
      prefs.setString("address", data['existingUser']['address']??"");
      prefs.setInt("userid", data['existingUser']['id']??0);
      print(prefs.getString("token"));
      Get.to(DashboardScreen());
    }else if(responce.statusCode==404){
      alertToastRed(context, "Invalid Otp");
    }else if(responce.statusCode==500){
      alertToastRed(context, "Internal Sever Error");

    }else{

    }

  }
}