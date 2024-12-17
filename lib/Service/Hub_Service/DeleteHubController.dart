import 'dart:convert';
import 'package:agaram_admin/Config.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Service/Hub_Service/GetallHubController.dart';
import 'package:agaram_admin/Widget/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteHubController extends GetConnect{

  Future<dynamic> DeleteHubApi(BuildContext context,id)async{
    final Getallhubcontroller getallhubcontroller=Get.find<Getallhubcontroller>();

    final SharedPreferences pref=await SharedPreferences.getInstance();

    String service;
    service=Config.LOGIN_API;
    final url=Uri.parse("${service}hub/user/deleteHubUser/$id");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final responce=await http.delete(url,headers: header);

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      await getallhubcontroller.GetAllHubApi(context,"","");
      StackDialog.show("Deleted Successfully", "Hub Deleted Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==500){
      Get.back();
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }

  }
}