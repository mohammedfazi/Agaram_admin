import 'dart:convert';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallOrder.dart';
import 'package:agaram_admin/Service/OrderHistory_Service/GetOrderHistoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import '../../Widget/Snackbar.dart';


class AssigncheckoutController extends GetConnect{
  final GetOrderHistoryController getallOrderController=Get.find<GetOrderHistoryController>();
  Future <dynamic> AssignCheckoutApi(BuildContext context,hubid,orderid)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();

    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}admin/assign/assignHubToCheckoutOrder");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };
    final json='{"hubuserId":"$hubid","orderId":"$orderid"}';

    final responce=await http.put(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      await getallOrderController.GetOrderHistoryAPI(context,"","");
      StackDialog.show("Successfully", "Order Assigned Successfully", Icons.verified, Colors.green);

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