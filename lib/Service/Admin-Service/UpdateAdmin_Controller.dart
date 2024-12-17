import 'dart:convert';
import 'package:agaram_admin/Service/Admin-Service/Getadmin_Controller.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class UpdateAdminController extends GetConnect{

  final GetAdminController getAdminController=Get.find<GetAdminController>();
  Future <dynamic> UpdateAdminAPI(BuildContext context,id,email,password,username,phone,profileimage)async{

    final SharedPreferences pref=await SharedPreferences.getInstance();
    String service;
    service=Config.API;

    final url=Uri.parse("${service}user/updateUser");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"id","$id","username":"$username","email":"$email","password":"$password","phone":"$phone","address":"","profileImage":"$profileimage","roleId":"2"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      await getAdminController.GetAdminApi(context);
      StackDialog.show("Successfully", "Admin Profile Updated Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}