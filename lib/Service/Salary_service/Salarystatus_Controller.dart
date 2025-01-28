import 'dart:convert';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:agaram_admin/Service/Users_service/SearchUsers_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class SalarystatusController extends GetConnect{


  Future <dynamic> SalarystatusAPI(BuildContext context)async{
    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}user/registerUser");

    final header=Config.Header;

    final json='{"username":"","email":"","password":"","phone":"","address":""';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      Get.back();
      StackDialog.show("Successfully", "User Created Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==409){
      StackDialog.show("Already Exists", "Enter Id Already Exists", Icons.info, Colors.red);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}