import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';


class GetSubscriptionByHubIdcontroller extends GetConnect{

  RxList<dynamic> getallsubscriptionhubdata=[].obs;
  Future <dynamic> GetSubscriptionByHubIdApi(BuildContext context,id)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;

    service=Config.LOGIN_API;
    final url=Uri.parse("${service}subscription/getSubscriptionHistoryHubAssigned?hubuserId=$id");
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
      final value=(data['subscriptionHistory']);
      getallsubscriptionhubdata.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}