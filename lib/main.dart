import 'package:agaram_admin/Screens/Login/Login_Controller.dart';
import 'package:agaram_admin/Screens/Splash_screen.dart';
import 'package:agaram_admin/Service/Admin-Service/Getadmin_Controller.dart';
import 'package:agaram_admin/Service/Admin-Service/UpdateAdmin_Controller.dart';
import 'package:agaram_admin/Service/Assign_service/AssignCheckout_Controller.dart';
import 'package:agaram_admin/Service/Assign_service/AssignSubscription_Controller.dart';
import 'package:agaram_admin/Service/CMS/GetcmspagebyIdController.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetOrderCount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetSubscriptioncount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetallPrice_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/Getalldeliveryuserscount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/Getproductscount_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/AddDeliverPartner_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/DeleteDeliverPartner_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/UpdateDeliveryUsers_Controller.dart';
import 'package:agaram_admin/Service/GetByHubId/GetDeliverbyHubId.dart';
import 'package:agaram_admin/Service/GetByHubId/GetUsersByHubId.dart';
import 'package:agaram_admin/Service/GetByHubId/GetallOrdersbyHubId.dart';
import 'package:agaram_admin/Service/GetByHubId/GetallSubscriptionbyHubId.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallOrder.dart';
import 'package:agaram_admin/Service/Hub_Service/AddHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/DeleteHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/GetallHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/UpdateHub_Controller.dart';
import 'package:agaram_admin/Service/OrderHistory_Service/GetOrderHistoryController.dart';
import 'package:agaram_admin/Service/Orders_Service/GetAdminallOrderByHubIdController.dart';
import 'package:agaram_admin/Service/Orders_Service/GetallOrdersController.dart';
import 'package:agaram_admin/Service/Password_Service/ChangePassword-Controller.dart';
import 'package:agaram_admin/Service/Password_Service/Forgetpassword_Controller.dart';
import 'package:agaram_admin/Service/Product-Service/AddProduct_Controller.dart';
import 'package:agaram_admin/Service/Product-Service/DeleteProduct_Controller.dart';
import 'package:agaram_admin/Service/Product-Service/UpdateProduct_Controller.dart';
import 'package:agaram_admin/Service/Subscription_Service/GetSubscriptionHistory_Controller.dart';
import 'package:agaram_admin/Service/Subscription_Service/Getseprate_Subscription_Controller.dart';
import 'package:agaram_admin/Service/Users_service/DeleteUser_Controller.dart';
import 'package:agaram_admin/Service/Users_service/UpdateUsers_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Service/Dashboard_Count/GetAllUsersCount_Controller.dart';
import 'Service/Product-Service/GetallProduct_Controller.dart';
import 'Service/Getall_Service/GetallUsers.dart';
import 'Service/Users_service/AddUsersController.dart';
import 'Service/Users_service/SearchUsers_Controller.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoginController());
  Get.put(GetallusersController());
  Get.put(GetalldeliveryController());
  Get.put(GetallOrderController());
  Get.put(GetalluserscountController());
  Get.put(GetOrdercountController());
  Get.put(GetallProductController());
  Get.put(AddUsersController());
  Get.put(GetalldeliveryuserscountController());
  Get.put(DeliveryUpdate_Controller());
  Get.put(AddDeliverpartnerController());
  Get.put(DeleteDeliveryPartnerController());
  Get.put(UpdateUsersController());
  Get.put(ForgetpasswordController());
  Get.put(ChangepasswordController());
  Get.put(GetAdminController());
  Get.put(UpdateAdminController());
  Get.put(AddProductController());
  Get.put(UpdateProductController());
  Get.put(GetSubscriptionHistoryController());
  Get.put(GetOrderHistoryController());
  Get.put(GetallpricecountController());
  Get.put(GetProductcountController());
  Get.put(GetSubscriptioncountController());
  Get.put(Getallhubcontroller());
  Get.put(AddHubController());
  Get.put(DeleteDeliveryPartnerController());
  Get.put(UpdateHubController());
  Get.put(DeleteProductController());
  Get.put(DeleteHubController());
  Get.put(GetCmsPagebyIdController());
  Get.put(GetSepratedateController());
  Get.put(GetUsersByHubIdcontroller());
  Get.put(GetDeliveryByHubIdcontroller());
  Get.put(GetOrderByHubIdcontroller());
  Get.put(AssigncheckoutController());
  Get.put(AssignSubscriptionController());
  Get.put(GetSubscriptionByHubIdcontroller());
  Get.put(DeleteUserController());
  Get.put(SearchUsersController());
  Get.put(GetAdminallOrdersController());
  Get.put(GetAdminallOrdersByHubIdController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Agaram Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}


