import 'dart:async';

import 'package:agaram_admin/Screens/Dashboard/Dashboard_screen.dart';
import 'package:agaram_admin/Screens/Login/Loginscreen.dart';
import 'package:agaram_admin/common/Asset_Constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void splashfun()async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 4), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
      pref.getString("session")==null?
      const Loginscreen():
      const DashboardScreen()
      ));
    });
  }

  @override
  void initState() {
splashfun();
super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(Asset_Constant.logo),
      ),
    );
  }
}
