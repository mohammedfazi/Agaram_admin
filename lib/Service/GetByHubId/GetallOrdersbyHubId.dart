import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';


class GetOrderByHubIdcontroller extends GetConnect{

  RxList<dynamic> getallorderhubdata=[].obs;
  Future <dynamic> GetOrderByHubIdApi(BuildContext context,id)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;

    service=Config.LOGIN_API;
    final url=Uri.parse("${service}checkout/getHubAssignedCheckoutHistory?hubuserId=$id");
    print(url);

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final responce=await http.get(url,headers:header);

    print(responce);
    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      final value=(data['checkoutHistory']);
      getallorderhubdata.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}