import 'package:agaram_admin/Screens/Dashboard/Dashboard_screen.dart';
import 'package:agaram_admin/Screens/Login/Login_Controller.dart';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:agaram_admin/Widget/Toast_dialog.dart';
import 'package:agaram_admin/common/Asset_Constant.dart';
import 'package:agaram_admin/common/Responsive.dart';
import 'package:agaram_admin/common/common%20Size.dart';
import 'package:agaram_admin/common/common%20Textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widget/common_textfield.dart';
import '../../common/Common color.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  int container=1;
  final LoginController loginController=Get.find<LoginController>();

  final TextEditingController emailcontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();
  final TextEditingController forgetemailcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Responsive(
      desktop: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(Asset_Constant.cowgrass,width: double.infinity,height: displayheight(context)*1,fit: BoxFit.cover,),
            Positioned(
              top: 80,
              right: 50,
              child: container==1?
              login():
              forgetpassword()
              ,
            )
          ],
        ),
      ),
      mobile: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(Asset_Constant.cowgrass,width: double.infinity,height: displayheight(context)*1,fit: BoxFit.cover,),
            Positioned(
              top: 120,
              bottom: 120,
              right: 10,
              left: 10,
              child: container==1?
              login():
              forgetpassword()
              ,
            )
          ],
        ),
      ),

    );
  }

  Widget login(){
    return Container(
      // height: displayheight(context)*0.80,
      width: displaywidth(context)*0.30,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Image.asset(Asset_Constant.logo,height: displayheight(context)*0.20,)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login",style: commonstyleweb(color: Colors.black,size: 25,weight: FontWeight.w700),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Email Id",style: commonstyle(color: Colors.black),),
                ),
                SizedBox(
                  // width: displaywidth(context)*0.20,
                    child: commontextfield("Enter Email Id", emailcontroller))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Password",style: commonstyle(color: Colors.black),),
                ),
                SizedBox(
                  // width: displaywidth(context)*0.20,
                    child: commontextfield("Enter Password", passwordcontroller))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                      onTap: (){
                        setState(() {
                          container=2;
                        });
                      },
                      child: Text("Forget Password",style: commonstyle(color: Colors.black,weight: FontWeight.w700),))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: displayheight(context)*0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )),
                        onPressed: (){
                          if(emailcontroller.text.isEmpty||passwordcontroller.text.isEmpty){
                            alertToastRed(context, "Required Field is Empty");
                          }else{
                            showloadingdialog(context);
                            // Get.to(DashboardScreen());
                            loginController.LoginApi(context, emailcontroller.text, passwordcontroller.text);
                            Get.back();
                          }
                        },
                        child: Text("SUBMIT",style: commonstyle(),))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget forgetpassword(){
    return Container(
      height: displayheight(context)*0.80,
      width: displaywidth(context)*0.30,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Image.asset(Asset_Constant.logo,height: displayheight(context)*0.20,)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Forget Password",style: commonstyleweb(color: Colors.black,size: 25,weight: FontWeight.w700),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enter the Registred Email Id will receive the password to reset.",style: commonstyle(color: Colors.black,size: 18),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Email Id",style: commonstyle(color: Colors.black),),
                ),
                SizedBox(
                  // width: displaywidth(context)*0.20,
                    child: commontextfield("Enter Email Id", forgetemailcontroller))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: displayheight(context)*0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )),
                        onPressed: (){
                          if(forgetemailcontroller.text.isEmpty){
                            alertToastRed(context, "Required Field is Empty");
                          }else{

                          }
                        },
                        child: Text("SUBMIT",style: commonstyle(),))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: (){
                    setState(() {
                      container=1;
                    });
                  },
                  child: Center(child: Text("Remember Password",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),))),
            ),
          ],
        ),
      ),
    );
  }
}
