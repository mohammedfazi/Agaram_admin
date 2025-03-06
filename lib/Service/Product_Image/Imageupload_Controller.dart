import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config.dart';
import '../../Widget/Snackbar.dart';


class Imageupload_Controller extends GetConnect{

  String?service;

  Future<dynamic> Imageupload_Api(BuildContext context,fileLocation,filetype,filename)async{

    final SharedPreferences pref=await SharedPreferences.getInstance();
    service=Config.LOGIN_API;

    final url = '${service}image/upload';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "${pref.getString('token')}"},

      body: json.encode({
        "imageURL": "$fileLocation",
        "originalname": filename,
        "description": "Customer Profile Image",
        "fileName": "Profile Image",
        "ImageType":"image/$filetype",
        "productId": "",
      }),
    );
    print(json.toString());
    if (response.statusCode == 201) {
      print('File Updated successfully');
      StackDialog.show("Successfully Uploaded", "Image Updated Successfully", Icons.verified, Colors.green);
      print(response.body);
      print(json.toString());
    } else {
      // print(fileLocation);
      StackDialog.show("File to Upload File", "Image Not Uploaded", Icons.info, Colors.red);
      print('Failed to upload file: ${response.statusCode}');
    }
  }

}