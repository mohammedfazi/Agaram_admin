import 'dart:convert';
import 'package:agaram_admin/Config.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:agaram_admin/Widget/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteUserController extends GetConnect{

  Future<dynamic> DeleteUserApi(BuildContext context,id)async{
    final GetallusersController getallusersController=Get.find<GetallusersController>();

    final SharedPreferences pref=await SharedPreferences.getInstance();

    String service;
    service=Config.LOGIN_API;
    final url=Uri.parse("${service}user/deleteUser/$id");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final responce=await http.delete(url,headers: header);

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      Get.back();
      await getallusersController.GetAllUsersApi(context);
      StackDialog.show("Deleted Successfully", "Customer Deleted Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==500){
      Get.back();
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }

  }
}