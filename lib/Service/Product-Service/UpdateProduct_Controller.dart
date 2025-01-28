import 'dart:convert';
import 'package:agaram_admin/Service/Product-Service/GetallProduct_Controller.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class UpdateProductController extends GetConnect{

  final GetallProductController getallProductController=Get.find<GetallProductController>();

  Future <dynamic> UpdateProductAPI(BuildContext context,id,productname,description,price,qty,issubscripe,productimage)async{
    String service;
    service=Config.LOGIN_API;
    final SharedPreferences pref=await SharedPreferences.getInstance();

    final url=Uri.parse("${service}product/updateProduct");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"id":"$id","productName":"$productname","productDescription":"$description","price":"$price","stockQty":"$qty","productImages":"$productimage","isSubscripe":"$issubscripe"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==201){
      await getallProductController.GetAllProductAPI(context,"","");
      Get.back();
      StackDialog.show("Successfully", "Product Updated Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}