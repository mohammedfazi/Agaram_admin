import 'dart:convert';
import 'package:agaram_admin/Config.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Widget/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteDeliveryPartnerController extends GetConnect{

Future<dynamic> DeleteDeliverPartnerApi(id)async{
  final GetalldeliveryController getalldeliveryController=Get.find<GetalldeliveryController>();

  final SharedPreferences pref=await SharedPreferences.getInstance();

  String service;
  service=Config.DRIVER_API;
  final url=Uri.parse("${service}user/deleteDeliveryUsers/$id");

  final header={
    "Accept":"application/json",
    "Content-type":"application/json",
    "Authorization":"Bearer ${pref.getString("token")}"
  };

  final responce=await http.delete(url,headers: header);

  final data=jsonDecode(responce.body);

  if(responce.statusCode==200){
    // await getalldeliveryController.GetAllDeliveryApi(context);
    Get.back();
    StackDialog.show("Deleted Successfully", "Delivery Partner Deleted Successfully", Icons.verified, Colors.green);
  }else if(responce.statusCode==500){
    StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
  }

}
}