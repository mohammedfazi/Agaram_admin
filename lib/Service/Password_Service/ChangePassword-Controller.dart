import 'dart:convert';
import 'package:agaram_admin/Widget/Toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';


class ChangepasswordController extends GetConnect{

  Future <dynamic> ChangepasswordApi(BuildContext context,oldpassword,newpassword)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();

    String service;
    service=Config.LOGIN_API;


    final url=Uri.parse("${service}password/changepassword");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"oldpassword":"$oldpassword","newpassword":"$newpassword"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      StackDialog.show("Successfully", "Password Changed Successfully", Icons.verified, Colors.green);
      alerttoastredgreen(context, "Password Changed Successfully");
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}