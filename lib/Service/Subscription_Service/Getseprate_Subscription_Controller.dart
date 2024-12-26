import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config.dart';

class GetSepratedateController extends GetConnect{

  RxList<dynamic> getsepratedata=[].obs;
  Future <dynamic> GetSeprateDateApi(BuildContext context,subscriptionid)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;
    int userId;
    var getid=pref.getInt("userid");
    userId=getid??0;
    service=Config.API;
    final url=Uri.parse("${service}vacation/getDeliveryHistorySeperate?userId=$userId&subscriptionId=$subscriptionid");
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
      final value=(data['getDeliveryHistory']);
      getsepratedata.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}


