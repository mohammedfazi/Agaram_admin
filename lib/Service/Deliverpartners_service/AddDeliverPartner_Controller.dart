import 'dart:convert';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Config.dart';
import '../../Widget/Snackbar.dart';


class AddDeliverpartnerController extends GetConnect{
 final GetalldeliveryController getalldeliveryController=Get.find<GetalldeliveryController>();
  Future <dynamic> AddDeliverPartnerApi(BuildContext context,email,password,username,phone,address,profileimage,kycverified,holdername,accountnumber,ifsccode,branchname,city,state,pincode)async{
    String service;
    service=Config.DRIVER_API;

    final url=Uri.parse("${service}user/registerUser");

    final header=Config.Header;

    final json='{"username":"$username","email":"$email","password":"$password","phone":"$phone","address":"$address","profileImage":"$profileimage","roleId":"3","kycIsVerified":"$kycverified","accountHolderName":"$holdername","accountNo":"$accountnumber","IFSCNO":"$ifsccode","branchName":"$branchname","city":"$city","state":"$state","pincode":"$pincode"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==201){
      await getalldeliveryController.GetAllDeliveryApi(context);
      Get.back();
      StackDialog.show("Successfully", "Deliver Partner Created Successfully", Icons.verified, Colors.green);

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