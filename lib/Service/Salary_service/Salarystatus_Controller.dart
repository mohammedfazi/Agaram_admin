import 'dart:convert';
import 'package:agaram_admin/Service/Salary_service/GetallSalary_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import 'package:http/http.dart' as http;
import '../../Widget/Snackbar.dart';

class SalarystatusController extends GetConnect{

  final GetallSalaryController getallSalaryController=Get.find<GetallSalaryController>();
  Future <dynamic> SalarystatusAPI(BuildContext context,id,status)async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    String service;
    service=Config.LOGIN_API;

    final url=Uri.parse("${service}hub/salary/completedStatus");

    final header={
      "Accept":"application/json",
      "Content-type":"application/json",
      "Authorization":"Bearer ${pref.getString("token")}"
    };

    final json='{"id":"$id","isCompleted":"$status"}';

    final responce=await http.post(url,headers:header,body: json.toString());

    final data=jsonDecode(responce.body);

    if(responce.statusCode==200){
      await getallSalaryController.GetAllSalaryApi(context);
      StackDialog.show("Successfully", "Status Updated Successfully", Icons.verified, Colors.green);
    }else if(responce.statusCode==409){
      StackDialog.show("Already Exists", "Enter Id Already Exists", Icons.info, Colors.red);
    }else if(responce.statusCode==500){
      StackDialog.show("Server Error", "Internal Server Error", Icons.info, Colors.red);
    }
    else{
      return null;
    }
  }
}