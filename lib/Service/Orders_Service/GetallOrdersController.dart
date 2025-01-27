import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';


class GetAdminallOrdersController extends GetConnect{

  RxList<dynamic> getallorderdata=[].obs;
  Future <dynamic> GetAdminAllOrderApi(BuildContext context)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;
    var date=DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    service=Config.LOGIN_API;
    final url=Uri.parse("${service}delivery/order/allDeliveryProductsCount?deliveryDay=$formattedDate");
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
      final value=(data['totalProductsCount']);
      getallorderdata.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}