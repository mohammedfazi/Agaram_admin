import 'dart:convert';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class AddUsersController extends GetConnect{

  final GetallusersController getallusersController=Get.find<GetallusersController>();
  Future <dynamic> AddUserAPI(BuildContext context,email,password,username,phone,address,profileimage,city,state,pincode)async{
    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}user/registerUser");

    final header=Config.Header;

    final json='{"username":"$username","email":"$email","password":"$password","phone":"$phone","address":"$address","profileImage":"$profileimage","roleId":"2","city":"$city","state":"$state","pincode":"$pincode"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==201){
      await getallusersController.GetAllUsersApi(context);
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