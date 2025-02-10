import 'dart:convert';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:agaram_admin/Widget/Toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import '../../Widget/Snackbar.dart';
import '../Dashboard/Dashboard_screen.dart';

class LoginController extends GetConnect{

  Future <dynamic> LoginApi(BuildContext context,email)async{
    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}auth/login");

    final header=Config.Header;

    final json='{"phone":"$email","roleId":"1"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      alerttoastredgreen(context, "Mobile Number Verified");
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