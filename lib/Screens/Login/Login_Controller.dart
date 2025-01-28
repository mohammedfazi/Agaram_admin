import 'dart:convert';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import '../../Widget/Snackbar.dart';
import '../Dashboard/Dashboard_screen.dart';

class LoginController extends GetConnect{

  Future <dynamic> LoginApi(BuildContext context,email,password)async{
    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}auth/login");

    final header=Config.Header;

    final json='{"email":"$email","password":"$password","roleId":"1"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      showloadingdialog(context);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("session","1");
      prefs.setString("token", data['token']??"");
      print("Token : $data['token']");
      prefs.setString("address", data['existingUser']['address']??"");
      prefs.setInt("userid", data['existingUser']['id']??0);
      print(prefs.getString("token"));
      Get.back();
      Get.to(const DashboardScreen());
      StackDialog.show("Successfully", "Successfully Logged In", Icons.verified, Colors.green);

    }else if(responce.statusCode==400){
      StackDialog.show("Not Found", "User Not Found", Icons.info, Colors.red);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      StackDialog.show("User Not Found", "", Icons.info, Colors.red);
    }
  }
}