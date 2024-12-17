import 'dart:convert';
import 'package:agaram_admin/Service/Hub_Service/GetallHubController.dart';
import 'package:agaram_admin/Service/Product-Service/GetallProduct_Controller.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class AddHubController extends GetConnect{

  final Getallhubcontroller getallhubcontroller=Get.find<Getallhubcontroller>();

  Future <dynamic> AddProductAPI(BuildContext context,username,emailid,password,phone,address,pincode,city)async{
    String service;
    service=Config.LOGIN_API;
    final SharedPreferences pref=await SharedPreferences.getInstance();

    final url=Uri.parse("${service}hub/user/registerHubUser");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"username":"$username","email":"$emailid","password":"$password","phone":"$phone","address":"$address","pincode":"$pincode","roleId":"4","city":"$city"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==201){
      await getallhubcontroller.GetAllHubApi(context,"","");
      Get.back();
      StackDialog.show("Successfully", "Hub Added Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==409){
      StackDialog.show("Already Exists", "Hub Already Exists", Icons.info, Colors.red);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}