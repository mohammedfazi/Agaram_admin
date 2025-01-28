import 'dart:convert';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class UpdateUsersController extends GetConnect{

  final GetallusersController getallusersController=Get.find<GetallusersController>();

  Future <dynamic> UpdateUserAPI(BuildContext context,id,email,password,username,phone,address,profileimage,hubuserid)async{
    String service;
    service=Config.LOGIN_API;
    final SharedPreferences pref=await SharedPreferences.getInstance();

    final url=Uri.parse("${service}user/updateUser");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"id":"$id","username":"$username","email":"$email","password":"$password","phone":"$phone","address":"$address","profileImage":"$profileimage","roleId":"2","hubuserId":"$hubuserid"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      Get.back();
      StackDialog.show("Successfully", "User Updated Successfully", Icons.verified, Colors.green);
      await getallusersController.GetAllUsersApi(context);
    }else if(responce.statusCode==400){
      StackDialog.show("Already Exists", "Enter Id Already Exists", Icons.info, Colors.red);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}