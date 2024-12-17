import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config.dart';

class GetProductcountController extends GetConnect{

  RxList<dynamic> getdata=[].obs;
  Future <dynamic> GetProductcountAPI(BuildContext context)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;

    service=Config.API;
    final url=Uri.parse("${service}dashboard/getProductsCount");
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
      final value=(data);
      getdata.assignAll([value]);
      return responce;

    }
    else{
      return responce;
    }
  }
}