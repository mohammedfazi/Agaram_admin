import 'package:agaram_admin/Screens/Dashboard/Dashboard_screen.dart';
import 'package:agaram_admin/Screens/Login/Login_Controller.dart';
import 'package:agaram_admin/Screens/Login/Otp_Controller.dart';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:agaram_admin/Widget/Toast_dialog.dart';
import 'package:agaram_admin/common/Asset_Constant.dart';
import 'package:agaram_admin/common/Responsive.dart';
import 'package:agaram_admin/common/common%20Size.dart';
import 'package:agaram_admin/common/common%20Textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../Widget/common_textfield.dart';
import '../../common/Common color.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  final pinController=TextEditingController();
  int container=1;
  final LoginController loginController=Get.find<LoginController>();
  final OtpController otpController=Get.find<OtpController>();

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
              Otpcontainer()
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
              Otpcontainer()
              ,
            )
          ],
        ),
      ),

    );
  }

  Widget login(){
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
              child: Text("Login",style: commonstyleweb(color: Colors.black,size: 25,weight: FontWeight.w700),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enter the Registered Mobile Number",style: commonstyle(color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: SizedBox(
                    // width: displaywidth(context)*0.20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: commonstyle(size: 20,color: Colors.black,weight: FontWeight.w700),
                          cursorColor: Colors.black,
                          controller: emailcontroller,
                          maxLines: 1,
                          maxLength: 10,
                          decoration: InputDecoration(
                            counterText: "",
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              fillColor: Colors.grey.shade400,
                              filled: true,
                              hintText: "Enter Mobile Number",
                              hintStyle: commonstyle()
                          ),
                        ),
                      )),
                )
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
                          if(emailcontroller.text.isEmpty){
                            alertToastRed(context, "Enter Mobile Number");
                          }else if(emailcontroller.text.length!=10){
                            alertToastRed(context, "Mobile Number Not Valid");
                          }
                          else{
                            showloadingdialog(context);
                            loginController.LoginApi(context, emailcontroller.text);
                            setState(() {
                              container=2;
                            });
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

  Widget Otpcontainer(){
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
              child: Text("Verification",style: commonstyleweb(color: Colors.black,size: 25,weight: FontWeight.w700),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0,top: 12.0,bottom: 10.0),
                  child: Text("Enter the verification code send to your phone number",style: commonstyle(size: 15,weight: FontWeight.w500,color: Colors.black),),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Pinput(
                        defaultPinTheme: PinTheme(
                          height: 60,
                          width: 60,
                          textStyle: commonstyle(size: 22,weight: FontWeight.w800,color: Colors.black),
                          decoration: BoxDecoration(
                            border: Border.all(color:  Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        length: 6,
                        onCompleted: (pin)=>print(pin),
                        controller: pinController,
                      ),
                    )
                ),
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
                          if(pinController.text.isEmpty){
                            alertToastRed(context, "Enter the OTP");
                          }else{
                            showloadingdialog(context);
                            otpController.OtpApi(context, emailcontroller.text, pinController.text);
                             Get.back();
                          }
                        },
                        child: Text("SUBMIT",style: commonstyle(),))),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
