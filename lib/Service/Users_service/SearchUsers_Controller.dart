import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config.dart';

class SearchUsersController extends GetConnect{

  RxList<dynamic> searchuserdata=[].obs;
  Future <dynamic> SearchUserAPI(BuildContext context,username,email)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String ?service;

    service=Config.LOGIN_API;
    final url=Uri.parse("${service}user/getUsers?username=$username&email=$email");
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
      final value=(data['users']);
      searchuserdata.assignAll(value);
      return responce;

    }
    else{
      return responce;
    }
  }
}