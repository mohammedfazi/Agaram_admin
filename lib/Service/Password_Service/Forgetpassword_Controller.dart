import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';


class ForgetpasswordController extends GetConnect{

  Future <dynamic> ForgetpasswordApi(BuildContext context,email)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();

    String service;
    service=Config.API;


    final url=Uri.parse("${service}password/forgotpassword");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"email":"$email"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      StackDialog.show("Successfully", "Password Sent Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else if(responce.statusCode==400){
      StackDialog.show("Not Found", "User Not Found", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}