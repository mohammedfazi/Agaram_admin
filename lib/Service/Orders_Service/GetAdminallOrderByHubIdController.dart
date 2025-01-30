import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';


class GetAdminallOrdersByHubIdController extends GetConnect{

  RxList<dynamic> getallorderdatabyhubid=[].obs;
  Future <dynamic> GetAdminAllOrderByHubIdApi(BuildContext context,id)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;

    var date=DateTime.now();
    DateTime nextdate=date.add(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(nextdate);
    service=Config.LOGIN_API;
    final url=Uri.parse("${service}delivery/order/allDeliveryProductsCountHub?deliveryDay=$formattedDate&hubuserId=$id");
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
      getallorderdatabyhubid.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}