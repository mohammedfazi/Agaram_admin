import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;
import 'package:agaram_admin/Service/GetByHubId/GetUsersByHubId.dart';
import 'package:pdf/pdf.dart';
import 'package:agaram_admin/Screens/Login/Loginscreen.dart';
import 'package:agaram_admin/Service/Admin-Service/Getadmin_Controller.dart';
import 'package:agaram_admin/Service/Admin-Service/UpdateAdmin_Controller.dart';
import 'package:agaram_admin/Service/CMS/GetcmspagebyIdController.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetAllUsersCount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetOrderCount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetSubscriptioncount_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/GetallPrice_Controller.dart';
import 'package:agaram_admin/Service/Dashboard_Count/Getalldeliveryuserscount_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/AddDeliverPartner_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/DeleteDeliverPartner_Controller.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/GetallDelivery.dart';
import 'package:agaram_admin/Service/Deliverpartners_service/UpdateDeliveryUsers_Controller.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallOrder.dart';
import 'package:agaram_admin/Service/Getall_Service/GetallUsers.dart';
import 'package:agaram_admin/Service/Hub_Service/AddHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/DeleteHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/GetallHubController.dart';
import 'package:agaram_admin/Service/Hub_Service/UpdateHub_Controller.dart';
import 'package:agaram_admin/Service/OrderHistory_Service/GetOrderHistoryController.dart';
import 'package:agaram_admin/Service/Password_Service/ChangePassword-Controller.dart';
import 'package:agaram_admin/Service/Password_Service/Forgetpassword_Controller.dart';
import 'package:agaram_admin/Service/Product-Service/AddProduct_Controller.dart';
import 'package:agaram_admin/Service/Product-Service/DeleteProduct_Controller.dart';
import 'package:agaram_admin/Service/Subscription_Service/GetSubscriptionHistory_Controller.dart';
import 'package:agaram_admin/Service/Subscription_Service/Getseprate_Subscription_Controller.dart';
import 'package:agaram_admin/Service/Users_service/SearchUsers_Controller.dart';
import 'package:agaram_admin/Service/Users_service/UpdateUsers_Controller.dart';
import 'package:agaram_admin/Widget/ShowDialog.dart';
import 'package:agaram_admin/Widget/Toast_dialog.dart';
import 'package:agaram_admin/Widget/common_textfield.dart';
import 'package:agaram_admin/common/Asset_Constant.dart';
import 'package:agaram_admin/common/Common%20color.dart';
import 'package:agaram_admin/common/Responsive.dart';
import 'package:agaram_admin/common/common%20Textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart'as pw;
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Service/Dashboard_Count/Getproductscount_Controller.dart';
import '../../Service/Product-Service/GetallProduct_Controller.dart';
import '../../Service/Users_service/AddUsersController.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  HtmlEditorController controller = HtmlEditorController();
  HtmlEditorController controller1 = HtmlEditorController();

  Uint8List? _customerimageBytes;
  String? _imageName;
  int ontaphub=2;
  int ontapinsidehub=1;
  String?filesize;
  String?filetype;
  String ?SelectedHubtoUsers;
  //PASSWORD
  final ForgetpasswordController forgetpasswordController=Get.find<ForgetpasswordController>();
  final ChangepasswordController changepasswordController=Get.find<ChangepasswordController>();

    Map <String,dynamic> ?Viewsubscriptiondata;
  Map <String,dynamic> ?Vieworderdata;

  void refreshuserdata()async{
    await getallusersController.GetAllUsersApi(context);
  }
  void _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    // Listen for file selection
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        print("No file selected.");
        return;
      }

      final file = files[0];
      final reader = html.FileReader();

      // Start reading the file as an array buffer
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((e) {
        if (reader.result != null) {
          try {
            // Update state with image bytes
            setState(() {
              _customerimageBytes = reader.result as Uint8List;
              _imageName = file.name;
            });

            // Debugging output
            print("File Name: ${file.name}");
            _imageName="${file.name}";
            filesize="${file.size}";
            filetype="${file.type}";
            print("File Size: ${file.size} bytes");
            print("Buffer (Uint8List): $_customerimageBytes");
          } catch (error) {
            print("Error processing file: $error");
          }
        } else {
          print("Failed to read file.");
        }
      });

      reader.onError.listen((e) {
        print("Error reading file: ${reader.error}");
      });
    });
  }
  final pdf = pw.Document();
  Future<Uint8List> _generatecustomerPDFnew(BuildContext context) async {
    final pdf = pw.Document();

    // Load the logo image (update the path to your logo's path)
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('Assets/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            // App bar with logo, background color, and title
            pw.Container(
              width: double.infinity,
              color: PdfColors.orange,
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 50, height: 50),
                  pw.Text(
                    "Agaram Customer Details",
                    style: pw.TextStyle(
                      fontSize: 24,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Column(
                children: [
                  // Subscription History Table
                  pw.Table.fromTextArray(
                    headers: ['Username','Email Id','Mobile Number','Address'],
                    data: getallusersController.getallusersdata.map((data) {
                      return [
                        data['username'] ?? "",
                        data['email'] ?? "",
                        data['phone']?? "",
                        data['address']??"",
                      ];
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generatedeliveryPDFnew(BuildContext context) async {
    try {
      // Fetch data
      await getalldeliveryController.GetAllDeliveryApi(context);
      print("Fetched data: ${getalldeliveryController.getalldeliverytdata}");
      if (getalldeliveryController.getalldeliverytdata.isEmpty) {
        throw Exception("No data available to generate PDF");
      }
      // Create the PDF document
      final pdf = pw.Document();
      final logoImage = pw.MemoryImage(
        (await rootBundle.load('Assets/logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                color: PdfColors.orange,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoImage, width: 50, height: 50),
                    pw.Text(
                      "Agaram Delivery Partners Details",
                      style: pw.TextStyle(
                        fontSize: 20,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Table.fromTextArray(
                  headers: ['Username', 'Email Id', 'Mobile Number', 'Address'],
                  headerStyle: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data:getalldeliveryController.getalldeliverytdata.map((data) {
                    return [
                      data['username'] ?? "",
                      data['email'] ?? "",
                      data['phone'] ?? "",
                      data['address'] ?? "",
                    ];
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
      return pdf.save();
    } catch (e) {
      print("Error generating PDF: $e");
      rethrow;
    }
  }

  Future<Uint8List> _generatehubPDFnew(BuildContext context) async {
    try {
      // Fetch data
      await getallhubcontroller.GetAllHubApi(context,"","");
      print("Fetched data: ${getallhubcontroller.getallhubdata}");
      if (getallhubcontroller.getallhubdata.isEmpty) {
        throw Exception("No data available to generate PDF");
      }
      // Create the PDF document
      final pdf = pw.Document();
      final logoImage = pw.MemoryImage(
        (await rootBundle.load('Assets/logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                color: PdfColors.orange,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoImage, width: 50, height: 50),
                    pw.Text(
                      "Agaram Hub Details",
                      style: pw.TextStyle(
                        fontSize: 20,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Table.fromTextArray(
                  headers: ['Username', 'Email Id', 'Mobile Number', 'Address'],
                  headerStyle: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data:getallhubcontroller.getallhubdata.map((data) {
                    return [
                      data['username'] ?? "",
                      data['email'] ?? "",
                      data['phone'] ?? "",
                      data['address'] ?? "",
                    ];
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
      return pdf.save();
    } catch (e) {
      print("Error generating PDF: $e");
      rethrow;
    }
  }

  //GET
  final GetallusersController getallusersController=Get.find<GetallusersController>();
  final GetalldeliveryController getalldeliveryController=Get.find<GetalldeliveryController>();
  final GetallOrderController getallOrderController=Get.find<GetallOrderController>();
  final GetalluserscountController getalluserscountController=Get.find<GetalluserscountController>();
  final GetallProductController getallProductController=Get.find<GetallProductController>();
  final GetAdminController getAdminController=Get.find<GetAdminController>();
  final GetalldeliveryuserscountController getalldeliveryuserscountController=Get.find<GetalldeliveryuserscountController>();
  final GetOrdercountController getOrdercountController=Get.find<GetOrdercountController>();
  final GetSubscriptionHistoryController getSubscriptionHistoryController=Get.find<GetSubscriptionHistoryController>();
  final GetOrderHistoryController getOrderHistoryController=Get.find<GetOrderHistoryController>();
  final GetallpricecountController getallpricecountController=Get.find<GetallpricecountController>();
  final GetProductcountController getProductcountController=Get.find<GetProductcountController>();
  final GetSubscriptioncountController getSubscriptioncountController=Get.find<GetSubscriptioncountController>();
  final SearchUsersController searchUsersController=Get.find<SearchUsersController>();
  final Getallhubcontroller getallhubcontroller=Get.find<Getallhubcontroller>();
  final GetCmsPagebyIdController getCmsPagebyIdControllerAbout=Get.find<GetCmsPagebyIdController>();
  final GetCmsPagebyIdController getCmsPagebyIdControllerTermsandconditions=Get.find<GetCmsPagebyIdController>();
  final GetSepratedateController getSepratedateController=Get.find<GetSepratedateController>();
  final GetUsersByHubIdcontroller getUsersByHubIdcontroller=Get.find<GetUsersByHubIdcontroller>();


  //UPDATE
  final UpdateUsersController updateUsersController=Get.find<UpdateUsersController>();
  final UpdateAdminController updateAdminController=Get.find<UpdateAdminController>();
  final DeliveryUpdate_Controller deliveryUpdate_Controller=Get.find<DeliveryUpdate_Controller>();
  final UpdateHubController updateHubController=Get.find<UpdateHubController>();

  //POST
  final AddUsersController addUsersController=Get.find<AddUsersController>();
  final AddDeliverpartnerController addDeliverpartnerController=Get.find<AddDeliverpartnerController>();
  final AddProductController addProductController=Get.find<AddProductController>();
  final AddHubController addHubController=Get.find<AddHubController>();

  //DELETE
  final DeleteDeliveryPartnerController deleteDeliveryPartnerController=Get.find<DeleteDeliveryPartnerController>();
  final DeleteProductController deleteProductController=Get.find<DeleteProductController>();
  final DeleteHubController deleteHubController=Get.find<DeleteHubController>();

  int container = 2;

  String?SelectedPaymentStatus;
  List<String> paymentlist=['COMPLETED','PENDING','CANCELED'];


  String?SelectedSubscriptionStatus;
  List<String> subscriptionlist=['Subscription Available','Subscription Not Available'];
  bool myprofilebool=false;
  bool mysettingbool=false;


  bool ?subscriptionstatusbool;
  int subscriptioncontainer=1;
  int ordercontainer=1;

  final TextEditingController hubsearchcontroller=TextEditingController();


  //search controller
  final TextEditingController subscriptionstatuscontroller=TextEditingController();
  final TextEditingController orderpaymentidcontroller=TextEditingController();
  final TextEditingController orderorderidcontroller=TextEditingController();
  final TextEditingController searchusernamecontroller=TextEditingController();
  final TextEditingController searchemailidcontroller=TextEditingController();
  final TextEditingController searchhubusernamecontroller=TextEditingController();
  final TextEditingController searchhubemailidcontroller=TextEditingController();
  final TextEditingController productsearchnamecontroller=TextEditingController();
  final TextEditingController productsearchpricecontroller=TextEditingController();




//add hub controller
  final TextEditingController hubnamecontroller=TextEditingController();
  final TextEditingController hubemailcontroller=TextEditingController();
  final TextEditingController hubnumbercontroller=TextEditingController();
  final TextEditingController hubpasswordcontroller=TextEditingController();
  final TextEditingController hubaddresscontroller=TextEditingController();
  final TextEditingController hubpincodecontroller=TextEditingController();
  final TextEditingController hubcitycontroller=TextEditingController();


  final TextEditingController updatehubnamecontroller=TextEditingController();
  final TextEditingController updatehubemailcontroller=TextEditingController();
  final TextEditingController updatehubnumbercontroller=TextEditingController();
  final TextEditingController updatehubpasswordcontroller=TextEditingController();
  final TextEditingController updatehubaddresscontroller=TextEditingController();
  final TextEditingController updatehubpincodecontroller=TextEditingController();
  final TextEditingController updatehubcitycontroller=TextEditingController();

  //add users controller
  final TextEditingController usernamecontroller=TextEditingController();
  final TextEditingController useremailcontroller=TextEditingController();
  final TextEditingController usernumbercontroller=TextEditingController();
  final TextEditingController useraddresscontroller=TextEditingController();
  final TextEditingController userpasswordcontroller=TextEditingController();
  final TextEditingController usercitycontroller=TextEditingController();
  final TextEditingController userstatecontroller=TextEditingController();
  final TextEditingController userpincodecontroller=TextEditingController();

  final TextEditingController updateusernamecontroller=TextEditingController();
  final TextEditingController updateuseremailcontroller=TextEditingController();
  final TextEditingController updateusernumbercontroller=TextEditingController();
  final TextEditingController updateuseraddresscontroller=TextEditingController();
  final TextEditingController updateusercitycontroller=TextEditingController();
  final TextEditingController updateuserstatecontroller=TextEditingController();
  final TextEditingController updateuserpincodecontroller=TextEditingController();


  //my profile controller
  final TextEditingController adminnamecontroller=TextEditingController();
  final TextEditingController adminemailcontroller=TextEditingController();
  final TextEditingController adminnumbercontroller=TextEditingController();

//change password controller
  final TextEditingController oldpasswordcontroller=TextEditingController();
  final TextEditingController newpasswordcontroller=TextEditingController();
  final TextEditingController confirmpasswordcontroller=TextEditingController();

  //Product controller

  //Delivery controller
  final TextEditingController deliverynamecontroller=TextEditingController();
  final TextEditingController deliveryemailcontroller=TextEditingController();
  final TextEditingController deliverynumbercontroller=TextEditingController();
  final TextEditingController deliveryaddresscontroller=TextEditingController();
  final TextEditingController deliverypasswordcontroller=TextEditingController();
  final TextEditingController deliverybanknamecontroller=TextEditingController();
  final TextEditingController deliveryaccountnumbercontroller=TextEditingController();
  final TextEditingController deliveryifsccodecontroller=TextEditingController();
  final TextEditingController deliverybranchcontroller=TextEditingController();
  final TextEditingController deliverycitycontroller=TextEditingController();
  final TextEditingController deliverystatecontroller=TextEditingController();
  final TextEditingController deliverypincodecontroller=TextEditingController();


  final TextEditingController deliveryupdatenamecontroller=TextEditingController();
  final TextEditingController deliveryupdateemailcontroller=TextEditingController();
  final TextEditingController deliveryupdatenumbercontroller=TextEditingController();
  final TextEditingController deliveryupdateaddresscontroller=TextEditingController();
  final TextEditingController deliveryupdatebanknamecontroller=TextEditingController();
  final TextEditingController deliveryupdateaccountnumbercontroller=TextEditingController();
  final TextEditingController deliveryupdateifsccodecontroller=TextEditingController();
  final TextEditingController deliveryupdatebranchcontroller=TextEditingController();


  //product Controller
  final TextEditingController productnamecontroller=TextEditingController();
  final TextEditingController productdescriptioncontroller=TextEditingController();
  final TextEditingController productpricecontroller=TextEditingController();
  final TextEditingController productqtycontroller=TextEditingController();

  final TextEditingController updateproductnamecontroller=TextEditingController();
  final TextEditingController updateproductdescriptioncontroller=TextEditingController();
  final TextEditingController updateproductpricecontroller=TextEditingController();
  final TextEditingController updateproductqtycontroller=TextEditingController();

  String ?selectedstatusnumber;
  String?Selectedsubscription;
  List<dynamic> Subscriptionlists=["Subscription Available,Subscription Not Available"];


  //bool password
  bool oldpassword=true;
  bool newpassword=true;
  bool confirmpassword=true;


  final picker = ImagePicker();
  List<XFile?> files = [null, null, null, null];
  List<String?> base64Strings = [null, null, null, null];
  List<String?> fileTypes = [null, null, null, null];


  Future<void> imagepicker(int index) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        files[index] = pickedImage;

        // Process the image
        List<int> imageBytes = File(pickedImage.path).readAsBytesSync();
        base64Strings[index] = base64Encode(imageBytes);

        print(base64Strings[index]);
        print(fileTypes);

        // Determine file type
        String fileName = pickedImage.path.split('/').last.toLowerCase();
        if (fileName.endsWith('.png')) {
          fileTypes[index] = 'png';
        } else if (fileName.endsWith('.jpg')) {
          fileTypes[index] = 'jpg';
        } else if (fileName.endsWith('.jpeg')) {
          fileTypes[index] = 'jpeg';
        } else {
          fileTypes[index] = 'unknown';
        }
      });
    }
  }


  Future<List<dynamic>> fetchProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1)); // Simulated delay
      return getallProductController.getdata;
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> fetchDeliveryboy() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1)); // Simulated delay
      return getalldeliveryController.getalldeliverytdata;
    } catch (e) {
      throw Exception('Failed to load Delivery Boys Data');
    }
  }



  List<ChartData> getChartData() {
    return [
      ChartData(
        'Delivery Partners',
        (getalluserscountController.getdata[0]['usersCount'] ?? 0).toDouble(),
        Colors.purple,
      ),
      ChartData(
        'Customers',
        (getalluserscountController.getdata[1]['usersCount'] ?? 0).toDouble(),
        Colors.orange,
      ),
    ];
  }

  final List<ChartData> chartData = [
    ChartData('Delivery Partners', 34, Colors.purple),
    ChartData('Customers', 76, Colors.orange),
  ];
  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior2;

  List<dynamic> dashboardgridview=[
    {
      "icon":Icons.shopping_cart_rounded,
      "title":"Total Orders",
      "amount":"12,088"
    },
    {
      "icon":Icons.delivery_dining,
      "title":"Total Delivery Boys",
      "amount":"10,500"
    },
    {
      "icon":Icons.person,
      "title":"Total Visitors",
      "amount":"2,56,259"
    },
    {
      "icon":Icons.paid,
      "title":"Total Income",
      "amount":"69,270"
    },
    {
      "icon":Icons.receipt,
      "title":"Total Subscription",
      "amount":"21,520"
    },
    {
      "icon":Icons.favorite,
      "title":"Total Products",
      "amount":"45,280"
    }
  ];

  List<dynamic> hubdashboardgridview=[
    {
      "icon":Icons.shopping_cart_rounded,
      "title":"Total Orders",
      "amount":"120"
    },
    {
      "icon":Icons.delivery_dining,
      "title":"Total Delivery Boys",
      "amount":"12"
    },
    {
      "icon":Icons.person,
      "title":"Total Visitors",
      "amount":"20"
    },
  ];

  final List<ChartData3> chartData3 = <ChartData3>[
    ChartData3("JAN", 12000),
    ChartData3("FEB", 11000),
    ChartData3("MAR", 5000),
    ChartData3("ARP", 9000),
    ChartData3("MAY", 8000),
    ChartData3("JUN", 7000),
    ChartData3("JUL",11000),
    ChartData3("AUG", 1000),
    ChartData3("SEP", 4000),
    ChartData3("OCT", 3000),
    ChartData3("NOV", 2000),
    ChartData3("DEC",1000),
  ];

  @override
  void initState() {
    getCmsPagebyIdControllerTermsandconditions.GetCMSPageByIdAPI(context, 3);
    getCmsPagebyIdControllerAbout.GetCMSPageByIdAPI(context, 1);
    getallhubcontroller.GetAllHubApi(context, "", "");
    searchUsersController.SearchUserAPI(context, "", "");
    getSubscriptioncountController.GetSubscriptioncountAPI(context);
    getProductcountController.GetProductcountAPI(context);
    getallpricecountController.GetAllpricecountAPI(context);
    getallusersController.GetAllUsersApi(context);
    getalldeliveryController.GetAllDeliveryApi(context);
    getallOrderController.GetAllOrderApi(context);
    getalluserscountController.GetAllusercountAPI(context);
    getallProductController.GetAllProductAPI(context,"","");
    getAdminController.GetAdminApi(context);
    getalldeliveryuserscountController.GetAlldeliveryuserscountAPI(context);
    getOrdercountController.GetOrdercountAPI(context);
    getSubscriptionHistoryController.GetSubscriptionHistoryAPI(context,"","");
    getOrderHistoryController.GetOrderHistoryAPI(context,"","");
    _tooltipBehavior=TooltipBehavior(enable: true);
    _tooltipBehavior2=TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Scaffold(
        backgroundColor: Color_Constant.primarycolr,
        body: Row(
          children: [
            Container(
              width: displaywidth(context) * 0.15,
              color: Color_Constant.primarycolr, // Adjust this color
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(Asset_Constant.logo)
                    ),
                    Column(
                      children: [
                        drawerwidget(1, CupertinoIcons.home, "Dashboard"),
                        drawerwidget(2, CupertinoIcons.building_2_fill, "Hub"),
                        drawerwidget(3, Icons.delivery_dining, "Delivery Partners"),
                        drawerwidget(4, CupertinoIcons.person, "Customers"),
                        drawerwidget(5, CupertinoIcons.cart_fill, "Product"),
                        drawerwidget(6, CupertinoIcons.info, "Order History"),
                        drawerwidget(14, CupertinoIcons.info, "Subscription History"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                mysettingbool=!mysettingbool;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: mysettingbool == true
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.settings,
                                          size: 15,
                                          color: mysettingbool == true?Colors.white:Colors.white.withOpacity(0.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "Setting",
                                            style: commonstyleweb(
                                              weight: FontWeight.w600,
                                              color: mysettingbool == true
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                      color: mysettingbool == true?Colors.white:Colors.white.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        mysettingbool==true?settingcontainer():Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // container = 9;
                                myprofilebool=!myprofilebool;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: myprofilebool == true
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.person,
                                          size: 15,
                                          color: myprofilebool == true?Colors.white:Colors.white.withOpacity(0.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "My Profile",
                                            style: commonstyleweb(
                                              weight: FontWeight.w600,
                                              color: myprofilebool == true
                                                  ? Colors.white
                                                  : Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                      color: myprofilebool == true?Colors.white:Colors.white.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        myprofilebool==true?myprofilecontainer():Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // container = 8;
                                Logout();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: container == 8
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 15,
                                      color: container==8?Colors.white:Colors.white.withOpacity(0.5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Logout",
                                        style: commonstyleweb(
                                          weight: FontWeight.w600,
                                          color: container == 8
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: displaywidth(context)*0.85,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: displayheight(context)*0.10,
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Agaram Diary Products",style: commonstyleweb(color: Colors.black,size: 20,weight: FontWeight.w700),),
                            InkWell(
                              onTap: (){
                                // PopupMenuButton<String>(
                                //   onSelected: (value){
                                //     print(value);
                                //   },
                                //   itemBuilder: (BuildContext context){
                                //     return[
                                //       PopupMenuItem(
                                //           child: "")
                                //     ]
                                //   },
                                // )
                              },
                              child: const CircleAvatar(
                                // radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(Asset_Constant.logo),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    container==1?
                    dashboard():
                    container==2 && ontaphub==1?
                    hubwidget():
                    container==2 && ontaphub==2?
                    Viewhubdetails():
                    container==3?
                    deliverywidget():
                    container==4?
                    customerwidget():
                    container==5?
                    productwidget():
                    container==6&&ordercontainer==1?
                    OrderHistory():
                    container==6&&ordercontainer==2?
                    ViewOrderHistory():
                    container==12?
                    Aboutuscms():
                    container==13?
                    Termsandconditionsscms():
                    container==10?
                    myprofile():
                    container==11?
                    changepasswordscreen():
                    container==14&&subscriptioncontainer==1?
                    SubscriptionHistory():
                    container==14&&subscriptioncontainer==2?
                    ViewSubscriptionHistory():
                    Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      mobile: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Color_Constant.primarycolr,
          leading: Builder(
            builder: (context) {
              return IconButton(onPressed: (){
                setState(() {
                  Scaffold.of(context).openDrawer();
                });
              }, icon:const Icon(Icons.sort,color: Colors.white,));
            }
          ),
          title:Text("Agaram Diary Products",style: commonstyleweb(color: Colors.black,size: 15,weight: FontWeight.w700),),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right:8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("${Asset_Constant.logo}"),
              ),
            )
          ],
        ),
        drawer:  Drawer(
          backgroundColor: Colors.white,
          child:   Container(
            width: displaywidth(context) * 0.15,
            color: Color_Constant.primarycolr, // Adjust this color
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(Asset_Constant.logo)
                  ),
                  Column(
                    children: [
                      drawerwidget(1, CupertinoIcons.home, "Dashboard"),
                      drawerwidget(2, CupertinoIcons.building_2_fill, "Hub"),
                      drawerwidget(3, Icons.delivery_dining, "Delivery Partners"),
                      drawerwidget(4, CupertinoIcons.person, "Customers"),
                      drawerwidget(5, CupertinoIcons.cart_fill, "Product"),
                      drawerwidget(6, CupertinoIcons.info, "Order History"),
                      drawerwidget(14, CupertinoIcons.info, "Subscription History"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // container = 8;
                              Logout();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: container == 8
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 15,
                                    color: container==8?Colors.white:Colors.white.withOpacity(0.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Logout",
                                      style: commonstyleweb(
                                        weight: FontWeight.w600,
                                        color: container == 8
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: container==1?
          dashboard():
          container==2?
          hubwidget():
          container==3?
          deliverywidget():
          container==4?
          customerwidgetmobile():
          container==5?
          productwidget():
          container==6&&ordercontainer==1?
          OrderHistory():
          container==6&&ordercontainer==2?
          ViewOrderHistory():
          container==12?
          Aboutuscms():
          container==13?
          Termsandconditionsscms():
          container==10?
          myprofile():
          container==11?
          changepasswordscreen():
          container==14&&subscriptioncontainer==1?
          SubscriptionHistory():
          container==14&&subscriptioncontainer==2?
          ViewSubscriptionHistory():
          Container()
        ),
      ),
    );
  }


  Widget mobiledashboard(){
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: displayheight(context)*0.33,
              width: double.infinity,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      mainAxisExtent: displayheight(context)*0.10,
                      crossAxisCount: 2),
                  itemCount: dashboardgridview.length,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: index==0?
                                    Colors.deepPurple.shade100:
                                    index==1?
                                    Colors.blue.shade100:
                                    index==2?
                                    Colors.red.shade100:
                                    index==3?
                                    Colors.orange.shade100:
                                    index==4?
                                    Colors.purple.shade100:
                                    Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: index==0?
                                        Colors.deepPurple:
                                        index==1?
                                        Colors.blue:
                                        index==2?
                                        Colors.red:
                                        index==3?
                                        Colors.orange:
                                        index==4?
                                        Colors.purple:
                                        Colors.green,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(dashboardgridview[index]['icon'],color: Colors.white,size: 15,),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${dashboardgridview[index]['title']??""}",style: commonstyle(color: Colors.grey.shade600,size: 12),),
                                    index==0?
                                    Obx(()=>getOrdercountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        : Text("${getOrdercountController.getdata[0]['deliveryOrderCount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)):
                                    index==1?
                                    Obx(()=>
                                    getalldeliveryuserscountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        :
                                    Text("${getalldeliveryuserscountController.getdata[0]['deliveryUserCount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)):
                                    index==2?
                                    Obx(()=>
                                    getalluserscountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        :
                                    Text("${getalluserscountController.getdata[0]['usersCount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)):
                                    index==3?
                                    Obx(()=>
                                    getallpricecountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        :
                                    Row(
                                      children: [
                                        const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                                        Text("${getallpricecountController.getdata[0]['totalAmount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),),
                                      ],
                                    )):
                                    index==4?
                                    Obx(()=>
                                    getSubscriptioncountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        :
                                    Text("${getSubscriptioncountController.getdata[0]['productCount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)):
                                    index==5?
                                    Obx(()=>
                                    getProductcountController.getdata.isEmpty?
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                        :
                                    Text("${getProductcountController.getdata[0]['productCount']??"0"}",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)):
                                    Text("0",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Total Number of Customers and Delivery Partners",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: displayheight(context)*0.42,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: SfCircularChart(
                        legend:  Legend(isVisible: true,position: LegendPosition.bottom,textStyle:commonstyle(color: Colors.black) ),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            // strokeColor: Colors.black,
                              enableTooltip: true,
                              dataSource: chartData,
                              pointColorMapper:(ChartData data,  _) => data.color,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Number of Sales for an Year",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: displayheight(context)*0.42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Fees Collection",style: commonstyle(weight: FontWeight.w700,size: 14),),
                        ),
                        SizedBox(
                          height: displayheight(context)*0.34,
                          width: double.infinity,
                          child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            legend: const Legend(isVisible: true,position: LegendPosition.bottom),
                            tooltipBehavior: _tooltipBehavior2,
                            primaryXAxis:  CategoryAxis(
                                labelStyle: commonstyle(color: Colors.black),
                                axisLine:const AxisLine(width: 0),
                                majorGridLines: const MajorGridLines(width: 0),
                                majorTickLines: const MajorTickLines(width: 0)
                            ),
                            primaryYAxis:  NumericAxis(
                                labelStyle: commonstyle(color: Colors.black),
                                axisLine:const AxisLine(width: 0),
                                majorGridLines: MajorGridLines(width: 0),
                                majorTickLines: MajorTickLines(width: 0)
                            ),
                            series: <CartesianSeries>[
                              SplineAreaSeries<ChartData3, String>(
                                  enableTooltip: true,
                                  borderColor: Colors.orange.shade800,
                                  name: "Sales",
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color_Constant.primarycolr.withOpacity(0.1),
                                        Color_Constant.primarycolr
                                      ]),
                                  dataSource: chartData3,
                                  xValueMapper: (ChartData3 data, _) => data.x,
                                  yValueMapper: (ChartData3 data, _) => data.y
                              ),
                            ],
                          ),
                        ),
      
      
                      ],
                    ),
                  ),
      
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              // height: displayheight(context)*0.42,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Top Products",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(color: Colors.black,thickness: 0.1,),
                  ),
                  SizedBox(
                    height: displayheight(context) * 0.35,
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchProducts(),
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Loading state
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // Error state
                          return Center(
                            child: Text(
                              "Error loading products",
                              style: commonstyle(color: Colors.red, weight: FontWeight.bold),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          // No data state
                          return Center(
                            child: Text(
                              "No products available",
                              style: commonstyle(color: Colors.black),
                            ),
                          );
                        } else {
                          // Success state
                          final data = snapshot.data!;
                          return ListView.builder(
                            itemCount: data.length > 5 ? 5 : data.length, // Limit to 5 items
                            itemBuilder: (BuildContext context, int index) {
                              var product = data[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageNetwork(
                                      image: "${product['productImages'] ?? ""}",
                                      height: 50,
                                      width: 50,
                                      duration: 200,
                                      curve: Curves.easeIn,
                                      onPointer: true,
                                      debugPrint: false,
                                      fullScreen: true,
                                      fitAndroidIos: BoxFit.cover,
                                      fitWeb: BoxFitWeb.cover,
                                      borderRadius: BorderRadius.circular(5),
                                      onLoading: const CupertinoActivityIndicator(
                                        color: Colors.indigoAccent,
                                      ),
                                      onError: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        debugPrint("©gabriel_patrick_souza");
                                      },
                                    ),
                                    Text(
                                      "${product['productName'] ?? ""}",
                                      style: commonstyle(color: Colors.black, weight: FontWeight.w600, size: 15),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.currency_rupee, color: Colors.black, size: 15),
                                        Text(
                                          "${product['price'] ?? ""}",
                                          style: commonstyle(color: Colors.black, size: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              // height: displayheight(context)*0.42,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Top Products",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(color: Colors.black,thickness: 0.1,),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.35,
                    child: Obx(
                          ()=> ListView.builder(
                          itemCount: min(getallusersController.getallusersdata.length,5),
                          itemBuilder: (BuildContext context,int index){
                            var data=getallusersController.getallusersdata[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  data['productImages']==null?
                                  Icon(Icons.info,color: Colors.grey,size: 50,)
                                      :ImageNetwork(
                                    image: "${data['productImages']??""}",
                                    height: 40,
                                    width: 40,
                                    duration: 200,
                                    curve: Curves.easeIn,
                                    onPointer: true,
                                    debugPrint: false,
                                    fullScreen: true,
                                    fitAndroidIos: BoxFit.cover,
                                    fitWeb: BoxFitWeb.cover,
                                    borderRadius: BorderRadius.circular(5),
                                    onLoading:  const CupertinoActivityIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.black,size: 40,
                                    ),
                                    onTap: () {
                                      debugPrint("©gabriel_patrick_souza");
                                    },
                                  ),
                                  Text("${data['username']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),
                                  Text("${data['phone']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),


                                  // Row(
                                  //   children: [
                                  //     const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                                  //     Text("${data['price']??""}",style: commonstyle(color: Colors.black,size: 15),),
                                  //   ],
                                  // )
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              // height: displayheight(context)*0.42,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Top Products",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(color: Colors.black,thickness: 0.1,),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.35,
                    child: Obx(
                          ()=> ListView.builder(
                          itemCount: min(getalldeliveryController.getalldeliverytdata.length,5),
                          itemBuilder: (BuildContext context,int index){
                            var data=getalldeliveryController.getalldeliverytdata[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ImageNetwork(
                                    image: "${data['profileImage']??""}",
                                    height: 50,
                                    width: 50,
                                    duration: 200,
                                    curve: Curves.easeIn,
                                    onPointer: true,
                                    debugPrint: false,
                                    fullScreen: true,
                                    fitAndroidIos: BoxFit.cover,
                                    fitWeb: BoxFitWeb.cover,
                                    borderRadius: BorderRadius.circular(5),
                                    onLoading:  const CupertinoActivityIndicator(
                                      color: Colors.indigoAccent,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.black,size: 40,
                                    ),
                                    onTap: () {
                                      debugPrint("©gabriel_patrick_souza");
                                    },
                                  ),
                                  Text("${data['username']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),
                                  Text("${data['phone']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),

                                  // Row(
                                  //   children: [
                                  //     const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                                  //     Text("${data['price']??""}",style: commonstyle(color: Colors.black,size: 15),),
                                  //   ],
                                  // )
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
      
        ],
      ),
    );
  }

  Widget dashboard(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                  height: displayheight(context)*0.42,
                  width: double.infinity,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          mainAxisExtent: displayheight(context)*0.20,
                          crossAxisCount: 3),
                      itemCount: dashboardgridview.length,
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: index==0?
                                        Colors.deepPurple.shade100:
                                        index==1?
                                        Colors.blue.shade100:
                                        index==2?
                                        Colors.red.shade100:
                                        index==3?
                                        Colors.orange.shade100:
                                        index==4?
                                        Colors.purple.shade100:
                                        Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: index==0?
                                            Colors.deepPurple:
                                            index==1?
                                            Colors.blue:
                                            index==2?
                                            Colors.red:
                                            index==3?
                                            Colors.orange:
                                            index==4?
                                            Colors.purple:
                                            Colors.green,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(dashboardgridview[index]['icon'],color: Colors.white,size: 20,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:18.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${dashboardgridview[index]['title']??""}",style: commonstyle(color: Colors.grey.shade600,size: 18),),
                                        index==0?
                                        Obx(()=>getOrdercountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            : Text("${getOrdercountController.getdata[0]['deliveryOrderCount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                        index==1?
                                        Obx(()=>
                                        getalldeliveryuserscountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            :
                                        Text("${getalldeliveryuserscountController.getdata[0]['deliveryUserCount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                        index==2?
                                        Obx(()=>
                                        getalluserscountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            :
                                        Text("${getalluserscountController.getdata[0]['usersCount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                        index==3?
                                        Obx(()=>
                                        getallpricecountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            :
                                        Row(
                                          children: [
                                            const Icon(Icons.currency_rupee,color: Colors.black,size: 20,),
                                            Text("${getallpricecountController.getdata[0]['totalAmount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),),
                                          ],
                                        )):
                                        index==4?
                                        Obx(()=>
                                        getSubscriptioncountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            :
                                        Text("${getSubscriptioncountController.getdata[0]['productCount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                        index==5?
                                        Obx(()=>
                                        getProductcountController.getdata.isEmpty?
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                            :
                                        Text("${getProductcountController.getdata[0]['productCount']??"0"}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                        Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  deliveranduserchart(),
                  expancechart()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: displaywidth(context) * 0.26,
                      height: displayheight(context) * 0.50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Text(
                              "Top Products",
                              style: commonstyleweb(color: Colors.black, weight: FontWeight.w700),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.black,
                              thickness: 0.1,
                            ),
                          ),
                          SizedBox(
                            height: displayheight(context) * 0.41,
                            child: FutureBuilder<List<dynamic>>(
                              future: fetchProducts(),
                              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Loading state
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // Error state
                                  return Center(
                                    child: Text(
                                      "Error loading products",
                                      style: commonstyle(color: Colors.red, weight: FontWeight.bold),
                                    ),
                                  );
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  // No data state
                                  return Center(
                                    child: Text(
                                      "No products available",
                                      style: commonstyle(color: Colors.black),
                                    ),
                                  );
                                } else {
                                  // Success state
                                  final data = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: data.length > 5 ? 5 : data.length, // Limit to 5 items
                                    itemBuilder: (BuildContext context, int index) {
                                      var product = data[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ImageNetwork(
                                              image: "${product['productImages'] ?? ""}",
                                              height: 50,
                                              width: 50,
                                              duration: 200,
                                              curve: Curves.easeIn,
                                              onPointer: true,
                                              debugPrint: false,
                                              fullScreen: true,
                                              fitAndroidIos: BoxFit.cover,
                                              fitWeb: BoxFitWeb.cover,
                                              borderRadius: BorderRadius.circular(5),
                                              onLoading: const CupertinoActivityIndicator(
                                                color: Colors.indigoAccent,
                                              ),
                                              onError: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                debugPrint("©gabriel_patrick_souza");
                                              },
                                            ),
                                            Text(
                                              "${product['productName'] ?? ""}",
                                              style: commonstyle(color: Colors.black, weight: FontWeight.w600, size: 15),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.currency_rupee, color: Colors.black, size: 15),
                                                Text(
                                                  "${product['price'] ?? ""}",
                                                  style: commonstyle(color: Colors.black, size: 15),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: displaywidth(context)*0.26,
                      height: displayheight(context)*0.50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0),
                            child: Text("Top Customers",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),),
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(color: Colors.black,thickness: 0.1,),
                          ),
                          SizedBox(
                            height: displayheight(context)*0.41,
                            child: Obx(
                                  ()=> ListView.builder(
                                  itemCount: min(getallusersController.getallusersdata.length,5),
                                  itemBuilder: (BuildContext context,int index){
                                    var data=getallusersController.getallusersdata[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          data['productImages']==null?
                                              const Icon(Icons.info,color: Colors.grey,size: 50,)
                                              :ImageNetwork(
                                            image: "${data['productImages']??""}",
                                            height: 40,
                                            width: 40,
                                            duration: 200,
                                            curve: Curves.easeIn,
                                            onPointer: true,
                                            debugPrint: false,
                                            fullScreen: true,
                                            fitAndroidIos: BoxFit.cover,
                                            fitWeb: BoxFitWeb.cover,
                                            borderRadius: BorderRadius.circular(5),
                                            onLoading:  const CupertinoActivityIndicator(
                                              color: Colors.indigoAccent,
                                            ),
                                            onError: const Icon(
                                              Icons.error,
                                              color: Colors.black,size: 40,
                                            ),
                                            onTap: () {
                                              debugPrint("©gabriel_patrick_souza");
                                            },
                                          ),
                                          Text("${data['username']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),
                                          Text("${data['phone']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),


                                          // Row(
                                          //   children: [
                                          //     const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                                          //     Text("${data['price']??""}",style: commonstyle(color: Colors.black,size: 15),),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: displaywidth(context)*0.26,
                      height: displayheight(context)*0.50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0),
                            child: Text("Top Deliver Partners",style: commonstyleweb(color: Colors.black,weight: FontWeight.w700),),
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(color: Colors.black,thickness: 0.1,),
                          ),
                          SizedBox(
                            height: displayheight(context)*0.41,
                            child: Obx(
                                  ()=> ListView.builder(
                                  itemCount: min(getalldeliveryController.getalldeliverytdata.length,5),
                                  itemBuilder: (BuildContext context,int index){
                                    var data=getalldeliveryController.getalldeliverytdata[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ImageNetwork(
                                            image: "${data['profileImage']??""}",
                                            height: 50,
                                            width: 50,
                                            duration: 200,
                                            curve: Curves.easeIn,
                                            onPointer: true,
                                            debugPrint: false,
                                            fullScreen: true,
                                            fitAndroidIos: BoxFit.cover,
                                            fitWeb: BoxFitWeb.cover,
                                            borderRadius: BorderRadius.circular(5),
                                            onLoading:  const CupertinoActivityIndicator(
                                              color: Colors.indigoAccent,
                                            ),
                                            onError: const Icon(
                                              Icons.error,
                                              color: Colors.black,size: 40,
                                            ),
                                            onTap: () {
                                              debugPrint("©gabriel_patrick_souza");
                                            },
                                          ),
                                          Text("${data['username']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),
                                          Text("${data['phone']??""}",style: commonstyle(color: Colors.black,weight: FontWeight.w600,size: 15),),

                                          // Row(
                                          //   children: [
                                          //     const Icon(Icons.currency_rupee,color: Colors.black,size: 15,),
                                          //     Text("${data['price']??""}",style: commonstyle(color: Colors.black,size: 15),),
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget OrderHistory(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Order Id..", orderorderidcontroller)),
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Payment Order Id..", orderpaymentidcontroller)),
                  // Padding(
                  //   padding: const EdgeInsets.only(left:8.0),
                  //   child: SizedBox(
                  //     height: displayheight(context)*0.07,
                  //     width: displaywidth(context)*0.30,
                  //     child: DropdownButtonFormField(
                  //       decoration:  InputDecoration(
                  //         enabledBorder: const OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.transparent)
                  //         ),
                  //         focusedBorder:const OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.transparent)
                  //         ),
                  //         fillColor: Colors.grey.shade400,
                  //         filled: true,
                  //       ),
                  //
                  //       value: SelectedPaymentStatus,
                  //       items: paymentlist.map((item) {
                  //         return DropdownMenuItem(
                  //           value: item,
                  //           child: Text(item,style: commonstyle(color: Colors.black),),
                  //           onTap: (){
                  //             setState(() {
                  //               SelectedPaymentStatus=item;
                  //             });
                  //           },
                  //         );
                  //       }).toList(),
                  //       dropdownColor: Colors.white,
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           SelectedPaymentStatus = newValue as String;
                  //         });
                  //       },
                  //
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      getOrderHistoryController.GetOrderHistoryAPI(context, orderpaymentidcontroller.text??"", orderorderidcontroller.text??"");
                    },
                    child: Container(
                      height:displayheight(context)*.06,
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,size: 20,),
                              Text("Search",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      getOrderHistoryController.GetOrderHistoryAPI(context, "","");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Container(
                        height:displayheight(context)*.06,
                        decoration: BoxDecoration(
                            color: Color_Constant.secondarycolr,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(Icons.refresh,color: Colors.white,size: 20,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("S.No",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Order Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Payment Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Payment Type",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total Price",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Payment Status",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child: Obx(
                          ()=> getOrderHistoryController.getorderdata.isEmpty?
                      const Center(
                        child: CupertinoActivityIndicator(),
                      )
                          :ListView.builder(
                          itemCount: getOrderHistoryController.getorderdata.length,
                          itemBuilder: (BuildContext context,int index){
                            var data=getOrderHistoryController.getorderdata[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        ordercontainer=2;
                                        Vieworderdata=getOrderHistoryController.getorderdata[index];
                                        print(Viewsubscriptiondata);
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${index+1}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.15,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['orderId']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.15,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['paymentId']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['paymentType']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.currency_rupee,size: 15,),
                                                      Text("${data['totalPrice']??""}",style: commonstyleweb(color: Colors.black),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: displaywidth(context)*0.10,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: data['paymentStatus']=="PENDING"?Colors.red.shade50:data['paymentStatus']=="COMPLETED"?Colors.green.shade50:Colors.orange.shade50
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['paymentStatus']??""}",style: commonstyleweb(color:
                                                  data['paymentStatus']=="PENDING"?Colors.red:data['paymentStatus']=="COMPLETED"?Colors.green:Colors.orange,weight: FontWeight.w600),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(onPressed: (){

                                                        }, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          setState(() {

                                                          });
                                                        }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade200,thickness: 0.5,)
                                ],
                              ),
                            );

                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget SubscriptionHistory(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.40,
                      child: commontextfield("Search By Subscription Order Id..", subscriptionstatuscontroller)),
                       Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: SizedBox(
                      height: displayheight(context)*0.07,
                      width: displaywidth(context)*0.30,
                      child: DropdownButtonFormField(
                        decoration:  InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent)
                          ),
                          focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent)
                          ),
                          fillColor: Colors.grey.shade400,
                          filled: true,
                        ),

                        value: SelectedPaymentStatus,
                        items: paymentlist.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item,style: commonstyle(color: Colors.black),),
                            onTap: (){
                              setState(() {
                                SelectedPaymentStatus=item;
                              });
                            },
                          );
                        }).toList(),
                        dropdownColor: Colors.white,
                        onChanged: (newValue) {
                          setState(() {
                            SelectedPaymentStatus = newValue as String;
                          });
                        },

                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      getSubscriptionHistoryController.GetSubscriptionHistoryAPI(context, SelectedPaymentStatus??"",subscriptionstatuscontroller.text??"");
                    },
                    child: Container(
                      height:displayheight(context)*.06,
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,size: 20,),
                              Text("Search",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      getSubscriptionHistoryController.GetSubscriptionHistoryAPI(context, "","");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Container(
                        height:displayheight(context)*.06,
                        decoration: BoxDecoration(
                            color: Color_Constant.secondarycolr,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(Icons.refresh,color: Colors.white,size: 20,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.05,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("S.No",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Subscription Order Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Product Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Product Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Start Date",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("End Date",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Payment Status",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child: Obx(
                          ()=> getSubscriptionHistoryController.getsubscriptiondata.isEmpty?
                      const Center(
                        child: CupertinoActivityIndicator(),
                      )
                          :ListView.builder(
                          itemCount: getSubscriptionHistoryController.getsubscriptiondata.length,
                          itemBuilder: (BuildContext context,int index){
                            var data=getSubscriptionHistoryController.getsubscriptiondata[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        getSepratedateController.GetSeprateDateApi(context,data['id']);
                                        subscriptioncontainer=2;
                                        Viewsubscriptiondata=getSubscriptionHistoryController.getsubscriptiondata[index];
                                        print(Viewsubscriptiondata);
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: displaywidth(context)*0.05,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${index+1}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.15,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['subscriptionOrderId']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context) * 0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ImageNetwork(
                                                    image: "${data['product']['productImages']}",
                                                    height: 50,
                                                    width: 50,
                                                    duration: 200,
                                                    curve: Curves.easeIn,
                                                    onPointer: true,
                                                    debugPrint: false,
                                                    fullScreen: true,
                                                    fitAndroidIos: BoxFit.cover,
                                                    fitWeb: BoxFitWeb.cover,
                                                    borderRadius: BorderRadius.circular(5),
                                                    onLoading:  const CupertinoActivityIndicator(
                                                      color: Colors.indigoAccent,
                                                    ),
                                                    onError: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () {
                                                      debugPrint("©gabriel_patrick_souza");
                                                    },
                                                  )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['product']['productName']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['startDate']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['endDate']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: displaywidth(context)*0.10,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: data['status']=="PENDING"?Colors.red.shade50:data['status']=="COMPLETED"?Colors.green.shade50:Colors.orange.shade50
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['status']??""}",style: commonstyleweb(color:
                                                  data['status']=="PENDING"?Colors.red:data['status']=="COMPLETED"?Colors.green:Colors.orange,weight: FontWeight.w600),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(onPressed: (){

                                                        }, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          setState(() {

                                                          });
                                                        }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade200,thickness: 0.5,)
                                ],
                              ),
                            );

                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ViewSubscriptionHistory(){
    List data=Viewsubscriptiondata?['deliverystatuses'];
    return Container(
      height: displayheight(context)*0.90,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        setState(() {
                          subscriptioncontainer=1;
                        });
                      }, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("View Subscription Details",style: commonstyleweb(color: Colors.black),),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Subscription Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Subscription Order Id : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['subscriptionOrderId']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Total Order Days : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['totalDate']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Subscription Start Date : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['startDate']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Subscription End Date  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['endDate']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Delivery Preference : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['preference']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Subscription Status  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['status']??""}",style: commonstyle(color: Viewsubscriptiondata?['status']=="PENDING"?Colors.red:Viewsubscriptiondata?['status']=="COMPLETED"?Colors.green:Colors.orange,size: 15,weight: FontWeight.w700),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Subscription History Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                  data.isEmpty?
                      Center(
                        child: Text("Subscription History Not Found",style: commonstyle(),),
                      )
                      : SizedBox(
                      height: displayheight(context)*0.40,
                      width: double.infinity,
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 80,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 5.0,
                              crossAxisCount: 3),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                child: ListTile(
                                  trailing: Text(data[index]['deliveryDate']??'', style: txtfieldbold),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: data[index]['deliveryStatus'] == "VACATION"
                                          ? Color_Constant.primarycolr
                                          : data[index]['deliveryStatus'] == "DELIVERED"
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${data[index]['deliveryStatus'] ?? ""}",
                                        style: btntxtwhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: Row(
                    //                     children: [
                    //                       Text("Customer Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                    //                       Text("${Viewsubscriptiondata?['user']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: Row(
                    //                     children: [
                    //                       Text("Customer Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                    //                       Text("${Viewsubscriptiondata?['user']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
                    //                     ],
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: Row(
                    //                     children: [
                    //                       Text("Customer Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                    //                       Text("${Viewsubscriptiondata?['user']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Text("Customer Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                    //                   Text("${Viewsubscriptiondata?['user']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("User Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['user']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['user']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['user']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Customer Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${Viewsubscriptiondata?['user']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                              ),
                
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Product Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageNetwork(
                                image: "${Viewsubscriptiondata?['product']['productImages']}",
                                height: 150,
                                width: 150,
                                duration: 200,
                                curve: Curves.easeIn,
                                onPointer: true,
                                debugPrint: false,
                                fullScreen: true,
                                fitAndroidIos: BoxFit.cover,
                                fitWeb: BoxFitWeb.cover,
                                borderRadius: BorderRadius.circular(5),
                                onLoading:  const CupertinoActivityIndicator(
                                  color: Colors.indigoAccent,
                                ),
                                onError: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  debugPrint("©gabriel_patrick_souza");
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(

                                            children: [
                                              Text("Product Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                              Text("${Viewsubscriptiondata?['product']['productName']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:20.0),
                                            child: Row(
                                              children: [
                                                Text("Product Price : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                                Text("${Viewsubscriptiondata?['product']['price']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("Product Quantity : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Viewsubscriptiondata?['product']['stockQty']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        
          ],
        ),
      ),
    );
  }

  Widget Viewhubdetails(){
    return Container(
      height: displayheight(context)*0.90,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        setState(() {
                          ontaphub=1;
                        });
                      }, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("View Hub Details",style: commonstyleweb(color: Colors.black,weight: FontWeight.w500),),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
                height: displayheight(context)*0.20,
                width: double.infinity,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        mainAxisExtent: displayheight(context)*0.20,
                        crossAxisCount: 3),
                    itemCount: hubdashboardgridview.length,
                    itemBuilder: (BuildContext context,int index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: index==0?
                                      Colors.deepPurple.shade100:
                                      index==1?
                                      Colors.blue.shade100:
                                      index==2?
                                      Colors.red.shade100:
                                      Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: index==0?
                                          Colors.deepPurple:
                                          index==1?
                                          Colors.blue:
                                          index==2?
                                          Colors.red:
                                          Colors.green,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Icon(hubdashboardgridview[index]['icon'],color: Colors.white,size: 20,),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${hubdashboardgridview[index]['title']??""}",style: commonstyle(color: Colors.grey.shade600,size: 18),),

                                      Text("${hubdashboardgridview[index]['amount']??""}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: displaywidth(context)*0.40,
                  decoration: BoxDecoration(
                    color: Color_Constant.primarycolr,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              ontapinsidehub=1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:ontapinsidehub==1?Colors.white:Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Text("Customers",style: commonstyle(color: ontapinsidehub==1?Colors.black:Colors.white,size: 15,weight: FontWeight.w500),),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              ontapinsidehub=2;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:ontapinsidehub==2?Colors.white:Colors.transparent,
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Text("Delivery Partners",style: commonstyle(color: ontapinsidehub==2?Colors.black:Colors.white,size: 15,weight: FontWeight.w500),),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              ontapinsidehub=3;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color:ontapinsidehub==3?Colors.white:Colors.transparent,
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Text("Order History",style: commonstyle(color: ontapinsidehub==3?Colors.black:Colors.white,size: 15,weight: FontWeight.w500),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color_Constant.primarycolr,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: displaywidth(context)*0.08,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("S.No",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.08,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("User Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.10,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("User Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.15,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Email Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.10,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Mobile Number",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.16,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("User Address",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.14,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: displayheight(context)*0.69,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: searchUsersController.searchuserdata.length,
                            itemBuilder: (BuildContext context,int index){
                              var data=searchUsersController.searchuserdata[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: displaywidth(context)*0.08,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${index+1}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.08,
                                              child: const Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage(Asset_Constant.logo),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['username']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.15,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['email']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['phone']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.16,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['address']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.14,
                                              child: Center(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          Map<String,dynamic> data=getallusersController.getallusersdata[index];
                                                          updateuserssidesheet(data:data);
                                                        }, icon: const Icon(CupertinoIcons.pen,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          // DeleteHub();
                                                        }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(color: Colors.grey.shade200,thickness: 0.5,)
                                  ],
                                ),
                              );

                            }),
                      )
                    ],
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }

  Widget ViewOrderHistory(){
    List getproductdata=Vieworderdata?['products']??[];
    return Container(
      height: displayheight(context)*0.90,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        setState(() {
                          ordercontainer=1;
                        });
                      }, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("View Order History Details",style: commonstyleweb(color: Colors.black),),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("CheckOut Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Order Id : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['orderId']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Payment Id : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['paymentId']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Payment Type : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['paymentType']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Total Amount  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("Rs : ${Vieworderdata?['totalPrice']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Delivery Preference : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['preference']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Payment Status  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['paymentStatus']??""}",style: commonstyle(color: Vieworderdata?['paymentStatus']=="PENDING"?Colors.red:Vieworderdata?['paymentStatus']=="COMPLETED"?Colors.green:Colors.orange,size: 15,weight: FontWeight.w700),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Delivery Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Customer Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${Vieworderdata?['user']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("User Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("Customer Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                          Text("${Vieworderdata?['user']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Customer Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${Vieworderdata?['user']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Product Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                    ),
                    SizedBox(
                      height:displayheight(context)*0.40,
                        width:double.infinity,
                        child:GridView.builder(
                          itemCount: getproductdata.length,
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                mainAxisExtent: displayheight(context)*0.17,
                                crossAxisCount: 2,),
                            itemBuilder: (BuildContext context,int index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ImageNetwork(
                                          image: "${getproductdata[index]['productImages']}",
                                          height: 100,
                                          width: 100,
                                          duration: 200,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: true,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius: BorderRadius.circular(5),
                                          onLoading:  const CupertinoActivityIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            debugPrint("©gabriel_patrick_souza");
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left:10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(

                                                      children: [
                                                        Text("Product Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                                        Text("${getproductdata[index]['productName']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:20.0),
                                                      child: Row(
                                                        children: [
                                                          Text("Product Price : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                                          Text("${getproductdata[index]['price']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text("Product Quantity : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                                    Text("${getproductdata[index]['stockQty']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                    )

                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Future<void> addhubsidesheet(int number){
    return SideSheet.right(
      sheetColor: Colors.white,
        width: number==1?displaywidth(context)*0.42:displaywidth(context)*0.90,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color_Constant.primarycolr,
                     borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Add Hub",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hub Profile Image",style: commonstyle(color: Colors.black),),
                ),
                Image.asset(Asset_Constant.logo,width: displaywidth(context)*0.10,),
                   number==1?
                    Column(
                      children: [
                        SizedBox(
                          width: displaywidth(context)*0.40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Hub Name",style: commonstyle(color: Colors.black),),
                                  ),
                                  SizedBox(
                                      width: displaywidth(context)*0.20,
                                      child: commontextfield("Enter Hub Name", hubnamecontroller))
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Hub Email Id",style: commonstyle(color: Colors.black),),
                                  ),
                                  SizedBox(
                                      width: displaywidth(context)*0.20,
                                      child: commontextfield("Enter Hub Email Id", hubemailcontroller))
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Hub Mobile Number",style: commonstyle(color: Colors.black),),
                                ),
                                SizedBox(
                                    width: displaywidth(context)*0.20,
                                    child: commontextfield("Enter Hub Mobile Number", hubnumbercontroller))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Hub Password",style: commonstyle(color: Colors.black),),
                                ),
                                SizedBox(
                                    width: displaywidth(context)*0.20,
                                    child: commontextfield("Enter Hub Password", hubpasswordcontroller))
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("City",style: commonstyle(color: Colors.black),),
                                ),
                                SizedBox(
                                    width: displaywidth(context)*0.20,
                                    child: commontextfield("Enter City", hubcitycontroller))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Pincode",style: commonstyle(color: Colors.black),),
                                ),
                                SizedBox(
                                    width: displaywidth(context)*0.20,
                                    child: commontextfield("Enter Pincode", hubpincodecontroller))
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Hub Address",style: commonstyle(color: Colors.black),),
                                  ),
                                  SizedBox(
                                      width: displaywidth(context)*0.40,
                                      child: commontextfield("Enter Hub Mobile Number", hubaddresscontroller,lines: 3))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hub Name",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Hub Name", hubnamecontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hub Email Id",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Hub Email Id", hubemailcontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hub Mobile Number",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Hub Mobile Number", hubnumbercontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hub Password",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Hub Password", hubpasswordcontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("City",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter City", hubcitycontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Pincode",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Pincode", hubpincodecontroller)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Hub Address",style: commonstyle(color: Colors.black),),
                            ),
                            commontextfield("Enter Hub Mobile Number", hubaddresscontroller,lines: 3)
                          ],
                        ),
                      ],
                    ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      height: displayheight(context)*0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: ()async{
                            showloadingdialog(context);
                            addHubController.AddProductAPI(context, hubnamecontroller.text??"", hubemailcontroller.text??"",
                                hubpasswordcontroller.text??"", hubnumbercontroller.text??"", hubaddresscontroller.text??"",
                                hubpincodecontroller.text??"", hubcitycontroller.text??"");
                            await getallhubcontroller.GetAllHubApi(context, "", "");
                            Get.back();
                          },
                          child: Text("SUBMIT",style: commonstyle(),))),
                )
              ],
            ),
          ),
        ),
        context: context);
  }

  Future<void> updatehubsidesheet({required Map<String, dynamic> data}){
    updatehubnamecontroller.text=data['username']??"";
    updatehubemailcontroller.text=data['email']??"";
    updatehubnumbercontroller.text=data['phone']??"";
    updatehubaddresscontroller.text=data['address']??"";
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color_Constant.primarycolr,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Update Hub",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Hub Profile Image",style: commonstyle(color: Colors.black),),
              ),
              Image.asset(Asset_Constant.logo,width: displaywidth(context)*0.10,),
              SizedBox(
                width: displaywidth(context)*0.40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Hub Name",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Hub Name", updatehubnamecontroller))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Hub Email Id",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Hub Email Id", updatehubemailcontroller))
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:displaywidth(context)*0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Hub Mobile Number",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Hub Mobile Number", updatehubnumbercontroller))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Hub Address",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.40,
                            child: commontextfield("Enter Address", updatehubaddresscontroller,lines: 3))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: displayheight(context)*0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )),
                        onPressed: (){
                          if(updateusernamecontroller.text.isEmpty||updateuseremailcontroller.text.isEmpty||updateusernumbercontroller.text.isEmpty||updateuseraddresscontroller.text.isEmpty){
                            alertToastRed(context, "Required Field is Empty");
                          }else{
                            updateHubController.UpdateProductAPI(context, data['id'], updatehubnamecontroller.text,
                                updatehubemailcontroller.text, data['password']??"", updatehubnumbercontroller.text, updatehubaddresscontroller.text, "", "");

                            getallhubcontroller.GetAllHubApi(context, "", "");
                            Get.back();
                          }
                        },
                        child: Text("UPDATE",style: commonstyle(),))),
              )
            ],
          ),
        ),
        context: context);
  }

  Future<void> adddeliverysidesheet(){
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.primarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Add Deliver Partner",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Personal Information",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Deliver Partner Profile Image",style: commonstyle(color: Colors.black),)),
                ),
                Center(child: Image.asset(Asset_Constant.logo,width: displaywidth(context)*0.10,)),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Driver Name", deliverynamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Email Id",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Driver Email Id", deliveryemailcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Padding(
                    padding: const EdgeInsets.only(left:4.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Driver Mobile Number",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.20,
                                child: commontextfield("Enter Driver Mobile Number", deliverynumbercontroller))
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
                                width: displaywidth(context)*0.20,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    style: commonstyle(size: 15,color: Colors.black,weight: FontWeight.w500),
                                    cursorColor: Colors.black,
                                    controller: deliverypasswordcontroller,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)
                                        ),
                                        fillColor: Colors.grey.shade400,
                                        filled: true,
                                        hintText: "Enter Password",
                                        hintStyle: commonstyle()
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("City",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter City", deliverycitycontroller))
                          ],
                        ),
                      ),
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("State",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter State", deliverystatecontroller))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width:displaywidth(context)*0.40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pincode",style: commonstyle(color: Colors.black),),
                      ),
                      SizedBox(
                          width: displaywidth(context)*0.40,
                          child: commontextfield("Enter Pincode", deliverypincodecontroller)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Address",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Driver Address", deliveryaddresscontroller,lines: 3))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Bank Information",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Account Holder's Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Account Holder's Name", deliverybanknamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Account Number",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Account Number", deliveryaccountnumbercontroller))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("IFSC Code",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter IFSC Number", deliveryifsccodecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Bank Branch Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Branch Name", deliverybranchcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Personal Documentation Upload",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Aadhaar Front", 0),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Aadhaar Back", 1),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload PAN Card", 2),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Driving License", 3),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      height: displayheight(context)*0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: ()async{
                            showloadingdialog(context);
                            setState(() async{
                              addDeliverpartnerController.AddDeliverPartnerApi(context, deliveryemailcontroller.text,
                                  deliverypasswordcontroller.text, deliverynamecontroller.text, deliverynumbercontroller.text,
                                  deliveryaddresscontroller.text, "", "false", deliverybanknamecontroller.text,
                                  deliveryaccountnumbercontroller.text, deliveryifsccodecontroller.text,
                                  deliverybranchcontroller.text,deliverycitycontroller.text,deliverystatecontroller.text,deliverypincodecontroller.text);
                              await getalldeliveryController.GetAllDeliveryApi(context);
                              Get.back();
                            });

                          },
                          child: Text("SUBMIT",style: commonstyle(),))),
                )
              ],
            ),
          ),
        ),
        context: context);
  }

  Future<void> updatedeliverysidesheet({required Map<String, dynamic> data}){
    deliverynamecontroller.text=data['username']??"";
    deliveryupdateemailcontroller.text=data['email']??"";
    deliveryupdatenumbercontroller.text=data['phone']??"";
    deliveryupdateaddresscontroller.text=data['address']??"";

    deliveryupdatebranchcontroller.text=data['branchName']??"";
    deliveryupdateifsccodecontroller.text=data['IFSCNO']??"";
    deliveryupdateaccountnumbercontroller.text=data['accountNo']??"";
    deliveryupdatenamecontroller.text=data['accountHolderName']??"";
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.primarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Update Deliver Partner",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Personal Information",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Deliver Partner Profile Image",style: commonstyle(color: Colors.black),)),
                ),
                Center(child: Image.asset(Asset_Constant.logo,width: displaywidth(context)*0.10,)),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Driver Name", deliverynamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Email Id",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Driver Email Id", deliveryupdateemailcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Mobile Number",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Driver Mobile Number", deliveryupdatenumbercontroller))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Driver Address",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Driver Address", deliveryupdateaddresscontroller,lines: 3))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Bank Information",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Account Holder's Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Account Holder's Name", deliveryupdatenamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Account Number",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Account Number", deliveryupdateaccountnumbercontroller))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("IFSC Code",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter IFSC Number", deliveryupdateifsccodecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Bank Branch Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Branch Name", deliveryupdatebranchcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Upload Documentation",style: commonstyle(size: 18,weight: FontWeight.w600,color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Aadhaar Front", 0),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Aadhaar Back", 1),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload PAN Card", 2),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildImageContainer("Upload Driving License", 3),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      height: displayheight(context)*0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: ()async{
                            // if(deliveryupdatenamecontroller.text.isEmpty||deliveryupdateemailcontroller.text.isEmpty||deliveryupdatenumbercontroller.text.isEmpty||
                            // deliveryupdateaddresscontroller.text.isEmpty||deliveryupdatebanknamecontroller.text.isEmpty||deliveryupdateaccountnumbercontroller.text.isEmpty||
                            // deliveryupdateifsccodecontroller.text.isEmpty||deliveryupdatebranchcontroller.text.isEmpty){
                            //   alertToastRed(context, "Required Field is Empty");
                            //
                            // }else{
                              showloadingdialog(context);
                              deliveryUpdate_Controller.DeliverUpdateApi(context, data['id']??1, deliveryupdateemailcontroller.text, data['password']??"",
                                  deliverynamecontroller.text, deliveryupdatenumbercontroller.text, deliveryupdateaddresscontroller.text,
                                  data['profileImage']??"", data['kycIsVerified'], deliveryupdatenamecontroller.text, deliveryupdateaccountnumbercontroller.text,
                                  deliveryupdateifsccodecontroller.text, deliveryupdatebranchcontroller.text);
                              await getalldeliveryController.GetAllDeliveryApi(context);
                            // }

                          },
                          child: Text("UPDATE DELIVERY PARTNER",style: commonstyle(),))),
                )
              ],
            ),
          ),
        ),
        context: context);
  }

  Widget buildImageContainer(String title, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: displayheight(context) * 0.06,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color_Constant.primarycolr,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                onTap: () {
                  // imagepicker(index);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: btntxtwhite),
                    const Icon(Icons.cloud_upload, color: Colors.white, size: 30),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: displayheight(context) * 0.20,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Color_Constant.primarycolr),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
            ),
            child: files[index] == null
                ? Center(child: Text("No Image Found", style: txtfield))
                : Image.file(File(files[index]!.path)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> addproductsidesheet(){
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color_Constant.primarycolr,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Add Product",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Product Image",style: commonstyle(color: Colors.black),),
              ),
              InkWell(
                onTap: () => _pickImage(), // Add parentheses to call the function
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: _customerimageBytes != null
                        ? InkWell(
                      onTap: () => _pickImage(), // Add parentheses here too
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _customerimageBytes!,
                          width: displaywidth(context) * 0.10,
                          height: displayheight(context)*0.10,
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: () => setState(() {
                        _pickImage();
                      }), // Add parentheses here as well
                      child: Image.asset(
                        Asset_Constant.logo,
                        width: displaywidth(context) * 0.10,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: displaywidth(context)*0.40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Product Name",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Name", productnamecontroller))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Price",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Price", productpricecontroller))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: displaywidth(context)*0.40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Quantity",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Quantity", productqtycontroller))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Subscription Status",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                          height: displayheight(context) * 0.07,
                          width: displaywidth(context) * 0.20,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              fillColor: Colors.grey.shade400,
                              filled: true,
                            ),
                            value: SelectedSubscriptionStatus,
                            items: subscriptionlist.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: commonstyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    SelectedSubscriptionStatus = item;
                                  });
                                },
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            onChanged: (newValue) {
                              setState(() {
                                SelectedSubscriptionStatus = newValue as String;
                                // Print the status based on the selected value
                                if (SelectedSubscriptionStatus == "Subscription Available") {
                                  subscriptionstatusbool=true;
                                  print(0); // Status 0
                                } else {
                                  subscriptionstatusbool=false;
                                  print(1); // Status 1
                                }
                              });
                            },
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Product Description",style: commonstyle(color: Colors.black),),
                    ),
                    commontextfield("Enter Product Description", productdescriptioncontroller,lines: 4)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: displayheight(context)*0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )),
                        onPressed: ()async{
                          final outputData = {
                            "fieldname": "productImages",
                            "originalname": _imageName.toString(),
                            "encoding": "7bit", // Default for file inputs
                            "mimetype":filetype,
                            "buffer": _customerimageBytes,
                            "size": filesize,
                          };
                          showloadingdialog(context);
                          addProductController.AddProductAPI(context, productnamecontroller.text, productdescriptioncontroller.text,
                              productpricecontroller.text, productqtycontroller.text, subscriptionstatusbool.toString(),
                              outputData);
                          await getallProductController.GetAllProductAPI(context,"","");
                        },
                        child: Text("SUBMIT",style: commonstyle(),))),
              )
            ],
          ),
        ),
        context: context);
  }

  Future<void> updateproductsidesheet({required Map<String, dynamic> data}){
    updateproductnamecontroller.text=data['productName']??"";
    updateproductdescriptioncontroller.text=data['productDescription']??"";
    updateproductpricecontroller.text=data['price']??"";
    updateproductqtycontroller.text=data['stockQty']??"";

    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color_Constant.primarycolr,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Update Product",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                      InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Product Image",style: commonstyle(color: Colors.black),),
              ),
              InkWell(
                onTap: () => _pickImage(), // Add parentheses to call the function
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: _customerimageBytes != null
                        ? InkWell(
                      onTap: () => _pickImage(), // Add parentheses here too
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _customerimageBytes!,
                          width: displaywidth(context) * 0.10,
                          height: displayheight(context)*0.10,
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: () => setState(() {
                        _pickImage();
                      }), // Add parentheses here as well
                      child: Image.asset(
                        Asset_Constant.logo,
                        width: displaywidth(context) * 0.10,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: displaywidth(context)*0.40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Product Name",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Name", updateproductnamecontroller))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Price",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Price", updateproductpricecontroller))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: displaywidth(context)*0.40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Quantity",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                            width: displaywidth(context)*0.20,
                            child: commontextfield("Enter Product Quantity", updateproductqtycontroller))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Subscription Status",style: commonstyle(color: Colors.black),),
                        ),
                        SizedBox(
                          height: displayheight(context) * 0.07,
                          width: displaywidth(context) * 0.20,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              fillColor: Colors.grey.shade400,
                              filled: true,
                            ),
                            value: SelectedSubscriptionStatus,
                            items: subscriptionlist.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: commonstyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    SelectedSubscriptionStatus = item;
                                  });
                                },
                              );
                            }).toList(),
                            dropdownColor: Colors.white,
                            onChanged: (newValue) {
                              setState(() {
                                SelectedSubscriptionStatus = newValue as String;
                                // Print the status based on the selected value
                                if (SelectedSubscriptionStatus == "Subscription Available") {
                                  subscriptionstatusbool=true;
                                  print(0); // Status 0
                                } else {
                                  subscriptionstatusbool=false;
                                  print(1); // Status 1
                                }
                              });
                            },
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Product Description",style: commonstyle(color: Colors.black),),
                    ),
                    commontextfield("Enter Product Description", updateproductdescriptioncontroller,lines: 4)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: displayheight(context)*0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )),
                        onPressed: ()async{
                          final outputData = {
                            "fieldname": "productImages",
                            "originalname": _imageName.toString(),
                            "encoding": "7bit", // Default for file inputs
                            "mimetype":filetype,
                            "buffer": _customerimageBytes,
                            "size": filesize,
                          };
                          showloadingdialog(context);

                          await getallProductController.GetAllProductAPI(context,"","");
                        },
                        child: Text("SUBMIT",style: commonstyle(),))),
              )
            ],
          ),
        ),
        context: context);
  }

  Future<void> adduserssidesheet(){
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.primarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Add Customers",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Customer Profile Image",style: commonstyle(color: Colors.black),),
                ),
                InkWell(
                  onTap: () => _pickImage(), // Add parentheses to call the function
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: _customerimageBytes != null
                          ? InkWell(
                        onTap: () => _pickImage(), // Add parentheses here too
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _customerimageBytes!,
                            width: displaywidth(context) * 0.10,
                            height: displayheight(context)*0.10,
                          ),
                        ),
                      )
                          : InkWell(
                        onTap: () => _pickImage(), // Add parentheses here as well
                        child: Image.asset(
                          Asset_Constant.logo,
                          width: displaywidth(context) * 0.10,
                        ),
                      ),
                    ),
                  ),
                ),
            
            
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Customer Name", usernamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Email Id",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Customer Email Id", useremailcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Customer Mobile Number",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter Customer Mobile Number", usernumbercontroller))
                          ],
                        ),
                      ),
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Password",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter Password", userpasswordcontroller))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("City",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter City", usercitycontroller))
                          ],
                        ),
                      ),
                      SizedBox(
                        width:displaywidth(context)*0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("State",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter State", userstatecontroller))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                    SizedBox(
            width:displaywidth(context)*0.40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Pincode",style: commonstyle(color: Colors.black),),
                ),
                SizedBox(
                    width: displaywidth(context)*0.40,
                    child: commontextfield("Enter Pincode", userpincodecontroller)),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Address",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Address", useraddresscontroller,lines: 3))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      height: displayheight(context)*0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: ()async{
                            if(usernamecontroller.text.isEmpty||useremailcontroller.text.isEmpty||usernumbercontroller.text.isEmpty||userpasswordcontroller.text.isEmpty||useraddresscontroller.text.isEmpty){
                              alertToastRed(context, "Required Field is Empty");
                            }else{
                              showloadingdialog(context);
                              addUsersController.AddUserAPI(context, useremailcontroller.text, userpasswordcontroller.text, usernamecontroller.text, usernumbercontroller.text, useraddresscontroller.text, _customerimageBytes.toString(),usercitycontroller.text,userstatecontroller.text,userpincodecontroller.text);
                              await getallusersController.GetAllUsersApi(context);
                            }
                          },
                          child: Text("SUBMIT",style: commonstyle(),))),
                )
              ],
            ),
                    ),
                  ]
              ),
          )
        ),
        context: context);
  }

  Future<void> updateuserssidesheet({required Map<String, dynamic> data}){
    updateusernamecontroller.text=data['username']??"";
    updateuseremailcontroller.text=data['email']??"";
    updateusernumbercontroller.text=data['phone']??"";
    updateuseraddresscontroller.text=data['address']??"";
    return SideSheet.right(
        sheetColor: Colors.white,
        width: displaywidth(context)*0.42,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.primarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Update Customers",style: commonstyleweb(color: Colors.white,size: 18,weight: FontWeight.w500),),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(Icons.clear,color: Color_Constant.primarycolr,),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Customer Profile Image",style: commonstyle(color: Colors.black),),
                ),
                Image.asset(Asset_Constant.logo,width: displaywidth(context)*0.10,),
                SizedBox(
                  width: displaywidth(context)*0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Name",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Customer Name", updateusernamecontroller))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Email Id",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.20,
                              child: commontextfield("Enter Customer Email Id", updateuseremailcontroller))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:displaywidth(context)*0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Customer Mobile Number",style: commonstyle(color: Colors.black),),
                            ),
                            SizedBox(
                                width: displaywidth(context)*0.40,
                                child: commontextfield("Enter Customer Mobile Number", updateusernumbercontroller))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Customer Address",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                              width: displaywidth(context)*0.40,
                              child: commontextfield("Enter Address", updateuseraddresscontroller,lines: 3))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Assign Customer to Hub",style: commonstyle(color: Colors.black),),
                          ),
                          SizedBox(
                            height:displayheight(context)*0.10,
                            width: displaywidth(context) * 0.39,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: "Select Hub",
                                hintStyle: commonstyle(),
                                fillColor: Colors.grey.shade400,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                                    borderRadius: BorderRadius.circular(10)),
                                border: const OutlineInputBorder(),
                              ),
                              value: SelectedHubtoUsers,
                              onChanged: (newValue) {
                                setState(() {
                                  SelectedHubtoUsers = newValue.toString();
                                });
                              },
                              items: getallhubcontroller.getallhubdata.map((item) {
                                return DropdownMenuItem(
                                  value: item['id'],
                                  child: Text("${item['username']+"-"+item['address']}", style: commonstyle(color: Colors.black)),
                                  onTap: () => setState(() {
                                    SelectedHubtoUsers = item['username'];
                                    print("Hub id - ${item['id']}");
                                  }),
                                );
                              }).toList(),
                              dropdownColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      height: displayheight(context)*0.06,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.primarycolr,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: (){
                            if(updateusernamecontroller.text.isEmpty||updateuseremailcontroller.text.isEmpty||updateusernumbercontroller.text.isEmpty||updateuseraddresscontroller.text.isEmpty){
                              alertToastRed(context, "Required Field is Empty");
                            }else{
                              updateUsersController.UpdateUserAPI(context, data['id']??1, updateuseremailcontroller.text,
                                  data['password']??"", updateusernamecontroller.text, updateusernumbercontroller.text,
                                  updateuseraddresscontroller.text, data['profileImage']??"");
                              getallusersController.GetAllUsersApi(context);
                              Get.back();
                            }
                          },
                          child: Text("UPDATE",style: commonstyle(),))),
                )
              ],
            ),
          ),
        ),
        context: context);
  }
  
  Widget hubwidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Hub Name", searchhubusernamecontroller)),
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Hub Email Id", searchhubemailidcontroller)),
                ],
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        getallhubcontroller.GetAllHubApi(context, searchhubusernamecontroller.text??"", searchhubemailidcontroller.text??"");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,),
                              Text("SEARCH",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      addhubsidesheet(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color_Constant.secondarycolr,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.add,color: Colors.white,),
                                Text("ADD HUB",style: commonstyle(),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      await Printing.sharePdf(
                          bytes:await _generatehubPDFnew(context),
                          filename: "Agaram Hub Details"
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.download_for_offline_outlined,color: Colors.white,),
                              Text("EXPORT",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.05,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("S.No",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Hub Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Hub Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Email Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Mobile Number",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: displaywidth(context)*0.05,
                          //   child: Center(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text("Pincode",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width: displaywidth(context)*0.16,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Hub Address",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.14,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child: Obx(
                            ()=> ListView.builder(
                        itemCount: getallhubcontroller.getallhubdata.length,
                          itemBuilder: (BuildContext context,int index){
                          var data=getallhubcontroller.getallhubdata[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        getUsersByHubIdcontroller.GetUserByHubIdApi(context,data['id']);
                                        ontaphub=2;
                                        print("Hub Id : ${data['id']}");
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: displaywidth(context)*0.05,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${index+1}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.08,
                                              child: const Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      backgroundImage: AssetImage(Asset_Constant.logo),
                                                    )
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['username']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.15,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SelectableText("${data['email']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.10,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['phone']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.16,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("${data['address']??""}",style: commonstyleweb(color: Colors.black),),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: displaywidth(context)*0.14,
                                              child: Center(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          updatehubsidesheet(data: data);
                                                        }, icon: const Icon(CupertinoIcons.pen,color: Colors.grey,size: 20,)),
                                                        IconButton(onPressed: (){
                                                          DeleteHub(data['id']??1);
                                                        }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade200,thickness: 0.5,)
                                ],
                              ),
                            );

                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget customerwidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Name", searchusernamecontroller)),
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Email Id", searchemailidcontroller)),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        searchUsersController.SearchUserAPI(context, searchusernamecontroller.text??"", searchemailidcontroller.text??"");
                      });
                     },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,),
                              Text("SEARCH",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      adduserssidesheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color_Constant.secondarycolr,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.add,color: Colors.white,),
                                Text("ADD USERS",style: commonstyle(),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      await Printing.sharePdf(
                          bytes:await _generatecustomerPDFnew(context),
                        filename: "Agaram Customer Details"
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.download_for_offline_outlined,color: Colors.white,),
                              Text("EXPORT",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Email Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Mobile Number",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.16,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Address",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.14,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: searchUsersController.searchuserdata.length,
                        itemBuilder: (BuildContext context,int index){
                        var data=searchUsersController.searchuserdata[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: displaywidth(context)*0.08,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['id']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.08,
                                          child: const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(Asset_Constant.logo),
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.10,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SelectableText("${data['username']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.15,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SelectableText("${data['email']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.10,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['phone']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.16,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['address']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.14,
                                          child: Center(
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                    IconButton(onPressed: (){
                                                      Map<String,dynamic> data=getallusersController.getallusersdata[index];
                                                      updateuserssidesheet(data:data);
                                                    }, icon: const Icon(CupertinoIcons.pen,color: Colors.grey,size: 20,)),
                                                    IconButton(onPressed: (){
                                                      // DeleteHub();
                                                    }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey.shade200,thickness: 0.5,)
                              ],
                            ),
                          );

                        }),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget deliverywidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width:displaywidth(context)*0.50,
                  child: commontextfield("Search By Id,Name..", hubsearchcontroller)),
              InkWell(
                onTap: (){
                  adddeliverysidesheet();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.secondarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.add,color: Colors.white,),
                          Text("Add Delivery Partner",style: commonstyle(),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  await Printing.sharePdf(
                      bytes:await _generatedeliveryPDFnew(context),
                      filename: "Agaram Delivery Partners Details"
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color_Constant.secondarycolr,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.download_for_offline_outlined,color: Colors.white,),
                          Text("EXPORT",style: commonstyle(),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("S.No",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Driver Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Driver Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Email Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Mobile Number",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.16,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Driver Address",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.14,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context) * 0.69,
                    width: double.infinity,
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchDeliveryboy(),
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: commonstyleweb(color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return  Center(
                            child: Text(
                              'Delivery Partners Not Found',
                              style:commonstyle(color: Colors.black),
                            ),
                          );
                        }

                        final deliveryData = snapshot.data!;

                        return ListView.builder(
                          itemCount: deliveryData.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = deliveryData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: displaywidth(context) * 0.08,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${index + 1}",
                                                  style: commonstyleweb(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.08,
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(Asset_Constant.logo),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.10,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${data['username'] ?? ""}",
                                                  style: commonstyleweb(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.15,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${data['email'] ?? ""}",
                                                  style: commonstyleweb(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.10,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${data['phone'] ?? ""}",
                                                  style: commonstyleweb(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.16,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${data['address'] ?? ""}",
                                                  style: commonstyleweb(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: displaywidth(context) * 0.14,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        // Handle view action
                                                      },
                                                      icon: const Icon(
                                                        CupertinoIcons.eye,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Map<String, dynamic> data = deliveryData[index];
                                                        updatedeliverysidesheet(data: data);
                                                      },
                                                      icon: const Icon(
                                                        CupertinoIcons.pen,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        DeleteDelivery(data['id'] ?? "");
                                                      },
                                                      icon: const Icon(
                                                        CupertinoIcons.delete,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(color: Colors.grey.shade200, thickness: 0.5),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget productwidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width:displaywidth(context)*0.30,
                  child: commontextfield("Search By Product Name ...", productsearchnamecontroller)),
              SizedBox(
                  width:displaywidth(context)*0.30,
                  child: commontextfield("Search By Product Price ...", productsearchpricecontroller)),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                       getallProductController.GetAllProductAPI(context, productsearchnamecontroller.text??"", productsearchpricecontroller.text??"");
                       },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,),
                              Text("Search",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      addproductsidesheet();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.add,color: Colors.white,),
                              Text("Add Product",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Product Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Product Image",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Product Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Price",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.20,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Description",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.14,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child:
                    FutureBuilder<List<dynamic>>(
                      future: fetchProducts(), // Your async function
                      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No products available'),
                          );
                        } else {
                          final products = snapshot.data!;
                          return Obx(
                            ()=> ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = products[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: displaywidth(context) * 0.08,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: commonstyleweb(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: displaywidth(context) * 0.08,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ImageNetwork(
                                                      image: "${data['productImages']}",
                                                      height: 100,
                                                      width: 100,
                                                      duration: 200,
                                                      curve: Curves.easeIn,
                                                      onPointer: true,
                                                      debugPrint: false,
                                                      fullScreen: true,
                                                      fitAndroidIos: BoxFit.cover,
                                                      fitWeb: BoxFitWeb.cover,
                                                      borderRadius: BorderRadius.circular(5),
                                                      onLoading:  const CupertinoActivityIndicator(
                                                        color: Colors.indigoAccent,
                                                      ),
                                                      onError: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                      onTap: () {
                                                        debugPrint("©gabriel_patrick_souza");
                                                      },
                                                    )
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: displaywidth(context) * 0.10,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "${data['productName'] ?? ""}",
                                                      style: commonstyleweb(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: displaywidth(context) * 0.10,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "${data['price'] ?? ""}",
                                                      style: commonstyleweb(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: displaywidth(context) * 0.20,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "${data['productDescription'] ?? ""}",
                                                      style: commonstyleweb(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: displaywidth(context) * 0.14,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            CupertinoIcons.eye,
                                                            color: Colors.grey,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            updateproductsidesheet(data: data);
                                                          },
                                                          icon: const Icon(
                                                            CupertinoIcons.pen,
                                                            color: Colors.grey,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            DeleteProduct(data['id']);
                                                          },
                                                          icon: const Icon(
                                                            CupertinoIcons.delete,
                                                            color: Colors.grey,
                                                            size: 20,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(color: Colors.grey.shade200,thickness: 0.5,)
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    )
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> DeleteHub(int id)async{
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Icon(CupertinoIcons.delete,color: Colors.red,size: 30,),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Are you sure you want to delete the Hub",style: commonstyleweb(color: Colors.black,size: 18,weight: FontWeight.w600),textAlign: TextAlign.center,),
        ),
        actions: [
          TextButton(onPressed: ()async{
            showloadingdialog(context);
            deleteHubController.DeleteHubApi(context, id);
            await getallhubcontroller.GetAllHubApi(context, "", "");
            Get.back();
          }, child: Text("Yes",style: commonstyleweb(color: Colors.black),)),
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style: commonstyleweb(color: Colors.black),))
        ],
      );
    });
  }

  Future<void> DeleteDelivery(int id)async{
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Icon(CupertinoIcons.delete,color: Colors.red,size: 30,),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Are you sure you want to delete the Delivery Partner",style: commonstyleweb(color: Colors.black,size: 18,weight: FontWeight.w600),textAlign: TextAlign.center,),
        ),
        actions: [
          TextButton(onPressed: ()async{
            showloadingdialog(context);
            deleteDeliveryPartnerController.DeleteDeliverPartnerApi(id);
             getalldeliveryController.GetAllDeliveryApi(context);
             Get.back();
          }, child: Text("Yes",style: commonstyleweb(color: Colors.black),)),
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style: commonstyleweb(color: Colors.black),))
        ],
      );
    });
  }

  Future<void> DeleteProduct(int id)async{
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Icon(CupertinoIcons.delete,color: Colors.red,size: 30,),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Are you sure you want to Delete the Product",style: commonstyleweb(color: Colors.black,size: 18,weight: FontWeight.w600),textAlign: TextAlign.center,),
        ),
        actions: [
          TextButton(onPressed: (){
            Get.back();
            showloadingdialog(context);
            deleteProductController.DeleteProductApi(context, id);
            Get.back();
          }, child: Text("Yes",style: commonstyleweb(color: Colors.black),)),
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style: commonstyleweb(color: Colors.black),))
        ],
      );
    });
  }

  Future<void> Logout()async{
    final SharedPreferences pref=await SharedPreferences.getInstance();
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Icon(Icons.logout,color: Colors.red,size: 30,),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Are you sure you want to Logout Agaram Admin",style: commonstyleweb(color: Colors.black,size: 18,weight: FontWeight.w600),textAlign: TextAlign.center,),
        ),
        actions: [
          TextButton(onPressed: (){
            pref.clear();
            Get.to(Loginscreen());
          }, child: Text("Yes",style: commonstyleweb(color: Colors.black),)),
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style: commonstyleweb(color: Colors.black),))
        ],
      );
    });
  }

  Widget deliveranduserchart(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Total Number of Customers and Delivery Partners",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
          ),
          Container(
            height: displayheight(context)*0.42,
            width: displaywidth(context)*0.27,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SfCircularChart(
                legend:  Legend(isVisible: true,position: LegendPosition.bottom,textStyle:commonstyle(color: Colors.black) ),
                tooltipBehavior: _tooltipBehavior,
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    // strokeColor: Colors.black,
                      enableTooltip: true,
                      dataSource: chartData,
                      pointColorMapper:(ChartData data,  _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y
                  )
                ]
            ),
          ),
        ],
      ),
    );

  }

  Widget expancechart(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Total Number of Sales for an Year",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
        ),
        Container(
          height: displayheight(context)*0.42,
          width: displaywidth(context)*0.55,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Fees Collection",style: commonstyle(weight: FontWeight.w700,size: 14),),
                ),
                SizedBox(
                  height: displayheight(context)*0.34,
                  width: displaywidth(context)*0.50,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    legend: const Legend(isVisible: true,position: LegendPosition.bottom),
                    tooltipBehavior: _tooltipBehavior2,
                    primaryXAxis:  CategoryAxis(
                        labelStyle: commonstyle(color: Colors.black),
                        axisLine:const AxisLine(width: 0),
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(width: 0)
                    ),
                    primaryYAxis:  NumericAxis(
                        labelStyle: commonstyle(color: Colors.black),
                        axisLine: AxisLine(width: 0),
                        majorGridLines:  MajorGridLines(width: 0),
                        majorTickLines:  MajorTickLines(width: 0)
                    ),
                    series: <CartesianSeries>[
                      SplineAreaSeries<ChartData3, String>(
                          enableTooltip: true,
                          borderColor: Colors.orange.shade800,
                          name: "Sales",
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color_Constant.primarycolr.withOpacity(0.1),
                                Color_Constant.primarycolr
                              ]),
                          dataSource: chartData3,
                          xValueMapper: (ChartData3 data, _) => data.x,
                          yValueMapper: (ChartData3 data, _) => data.y
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }

  Widget Aboutuscms(){
    String getaboutusdata=getCmsPagebyIdControllerAbout.getcmsdata[0]['pageContent'];
    controller.setText(getaboutusdata??"");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("About Us",style: commonstyle(size: 18,weight: FontWeight.w700,color: Colors.black),),
        ),
        Container(
            height: displayheight(context)*0.90,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlEditor(
                      controller: controller, //required
                      htmlEditorOptions: const HtmlEditorOptions(
                        hint: "Your text here...",
                      ),
                      otherOptions: const OtherOptions(
                        height: 400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: displayheight(context)*0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.secondarycolr,shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )),
                          onPressed: (){},
                          child: Center(child: Text("SUBMIT",style: btntxtwhite,))),
                    ),
                  )
                ],
              ),
            )

        ),
      ],
    );
  }

  Widget Termsandconditionsscms(){
    String gettermadata=getCmsPagebyIdControllerAbout.getcmsdata[0]['pageContent'];
    controller1.setText(gettermadata??"");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Terms and Conditions",style: commonstyle(size: 18,weight: FontWeight.w700,color: Colors.black),),
        ),
        Container(
          height: displayheight(context)*0.90,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HtmlEditor(
                      controller: controller1, //required
                      htmlEditorOptions: const HtmlEditorOptions(
                        hint: "Your text here...",
                      ),
                      otherOptions:const OtherOptions(
                        height: 400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: displayheight(context)*0.06,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.secondarycolr,shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )),
                          onPressed: (){},
                          child: Center(child: Text("SUBMIT",style: btntxtwhite,))),
                    ),
                  )
                ],
              ),
            )

        ),
      ],
    );
  }

  Widget drawerwidget(int number, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            container = number;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: container == number
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: container==number?Colors.white:Colors.white.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: commonstyleweb(
                      weight: FontWeight.w600,
                      color: container == number
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myprofilecontainer(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)
          ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Column(
            children: [
                  Padding(
                   padding: const EdgeInsets.all(8.0),
                     child: InkWell(
            onTap: () {
              setState(() {
                container = 10;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: container == 10
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      size: 15,
                      color: container==10?Colors.white:Colors.white.withOpacity(0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "My Profile",
                        style: commonstyleweb(
                          weight: FontWeight.w600,
                          color: container == 10
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
                     ),
                      Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      container = 11;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: container == 11
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 15,
                            color: container==1?Colors.white:Colors.white.withOpacity(0.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Change Password",
                              style: commonstyleweb(
                                weight: FontWeight.w600,
                                color: container == 11
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget settingcontainer(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      container = 12;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: container == 12
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 15,
                            color: container==12?Colors.white:Colors.white.withOpacity(0.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "About Us",
                              style: commonstyleweb(
                                weight: FontWeight.w600,
                                color: container == 12
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      container = 13;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: container == 13
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 13,
                            color: container==13?Colors.white:Colors.white.withOpacity(0.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Terms & Conditions",
                              style: commonstyleweb(
                                weight: FontWeight.w600,
                                color: container == 13
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),


      ),
    );
  }

  Widget myprofile(){
    adminnamecontroller.text=getAdminController.getadmindata[0]['username']??"";
    adminemailcontroller.text=getAdminController.getadmindata[0]['email']??"";
    adminnumbercontroller.text=getAdminController.getadmindata[0]['phone']??"";
    return Container(
      height: displayheight(context)*0.90,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("My Profile",style: commonstyle(color: Colors.black,weight: FontWeight.w500,size: 20),)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("Username",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: commontextfield("Enter Username", adminnamecontroller),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("Email Id",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: commontextfield("Enter Email Id", adminemailcontroller),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("Mobile Number",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: commontextfield("Enter Mobile Number", adminnumbercontroller),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        height: displayheight(context)*0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.secondarycolr,shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )),
                            onPressed: (){
                              if(adminnamecontroller.text.isEmpty||adminemailcontroller.text.isEmpty||adminnumbercontroller.text.isEmpty){
                                alertToastRed(context, "Required Field is Empty");
                              }else{
                                showloadingdialog(context);
                                updateAdminController.UpdateAdminAPI(context, getAdminController.getadmindata[0]['id']??"", adminemailcontroller.text, getAdminController.getadmindata[0]['password']??"",
                                    adminemailcontroller.text, adminnumbercontroller.text, "");
                                Get.back();
                              }
                            },
                            child: Center(child: Text("UPDATE",style: btntxtwhite,))),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget changepasswordscreen(){
    return Container(
      height: displayheight(context)*0.90,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Change Password",style: commonstyle(color: Colors.black,weight: FontWeight.w500,size: 20),)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("Old Password",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: commonstyle(size: 15),
                            cursorColor: Colors.black,
                            controller: oldpasswordcontroller,
                            maxLines: 1,
                            obscureText: oldpassword,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    oldpassword=!oldpassword;
                                  });
                                }, icon:Icon(oldpassword?CupertinoIcons.eye:CupertinoIcons.eye_slash) ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                focusedBorder:const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                fillColor: Colors.grey.shade400,
                                filled: true,
                                hintText: "Enter Old password",
                                hintStyle: commonstyle()
                            ),
                          ),
                        )
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("New Password",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: commonstyle(size: 15),
                        cursorColor: Colors.black,
                        controller: newpasswordcontroller,
                        maxLines: 1,
                        obscureText: newpassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              newpassword=!newpassword;
                            });
                          }, icon:Icon(newpassword?CupertinoIcons.eye:CupertinoIcons.eye_slash) ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            focusedBorder:const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            fillColor: Colors.grey.shade400,
                            filled: true,
                            hintText: "Enter New password",
                            hintStyle: commonstyle()
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text("Confirm New Password",style: commonstyle(color: Colors.black,weight: FontWeight.w600),),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: commonstyle(size: 15),
                          cursorColor: Colors.black,
                          controller: confirmpasswordcontroller,
                          maxLines: 1,
                          obscureText: confirmpassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(onPressed: (){
                                setState(() {
                                  confirmpassword=!confirmpassword;
                                });
                              }, icon:Icon(confirmpassword?CupertinoIcons.eye:CupertinoIcons.eye_slash) ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent)
                              ),
                              fillColor: Colors.grey.shade400,
                              filled: true,
                              hintText: "Enter Confirm New password",
                              hintStyle: commonstyle()
                          ),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        height: displayheight(context)*0.06,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color_Constant.secondarycolr,shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )),
                            onPressed: (){},
                            child: Center(child: Text("SUBMIT",style: btntxtwhite,))),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double displaywidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  double displayheight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  Widget hubwidgetmobile(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.48,
                      child: commontextfield("Search By Hub Name", searchhubusernamecontroller)),
                  SizedBox(
                      width:displaywidth(context)*0.48,
                      child: commontextfield("Search By Hub Email Id", searchhubemailidcontroller)),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      getallhubcontroller.GetAllHubApi(context, searchhubusernamecontroller.text??"", searchhubemailidcontroller.text??"");
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.secondarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.search,color: Colors.white,),
                            Text("SEARCH",style: commonstyle(),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
              Padding(
              padding: const EdgeInsets.all(8.0),
               child:
                Container(
                width: double.infinity,
                decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Header Row
                Container(
                width: displaywidth(context) * 2.80,
                decoration: BoxDecoration(
                color: Color_Constant.primarycolr,
                borderRadius: BorderRadius.circular(10)),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                children: [
                _buildHeaderCell("Hub Id", 0.20),
                _buildHeaderCell("Hub Profile", 0.25),
                _buildHeaderCell("Hub Name", 0.40),
                _buildHeaderCell("Email Id", 0.50),
                _buildHeaderCell("Mobile Number", 0.40),
                _buildHeaderCell("Hub Address", 0.70),
                _buildHeaderCell("Actions", 0.30),
                ],
                ),
                ),
                ),
                // List View
                SizedBox(
                height: displayheight(context) * 0.90,
                width: displaywidth(context) * 2.80,
                child: Obx(
                () => ListView.builder(
                itemCount: getallhubcontroller.getallhubdata.length,
                itemBuilder: (BuildContext context, int index) {
                var data = getallhubcontroller.getallhubdata[index];
                return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                children: [
                Container(
                width: double.infinity,
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                children: [
                _buildRowCell("${index + 1}", 0.20),
                _buildRowCell(
                "",
                0.25,
                isCircle: true,
                ),
                _buildRowCell(data['username'] ?? "", 0.40),
                _buildRowCell(data['email'] ?? "", 0.50),
                _buildRowCell(data['phone'] ?? "", 0.40),
                _buildRowCell(data['address'] ?? "", 0.70),
                _buildActionCell(data['id']),
                ],
                ),
                ),
                ),
                Divider(
                color: Colors.grey.shade200,
                thickness: 0.5,
                ),
                ],
                ),
                );
                },
                ),
                ),
                ),
                ],
                ),
                ),
                ),
                ),
                ),
              )

    ],
    );
  }

  Widget customerwidgetmobile(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Name", searchusernamecontroller)),
                  SizedBox(
                      width:displaywidth(context)*0.30,
                      child: commontextfield("Search By Email Id", searchemailidcontroller)),
                ],
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        searchUsersController.SearchUserAPI(context, searchusernamecontroller.text??"", searchemailidcontroller.text??"");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Colors.white,),
                              Text("SEARCH",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: displaywidth(context)*0.02,),
                  InkWell(
                    onTap: (){
                      adduserssidesheet();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color_Constant.secondarycolr,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Icon(Icons.add,color: Colors.white,),
                              Text("ADD USERS",style: commonstyle(),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color_Constant.primarycolr,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Profile",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Name",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.15,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Email Id",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.10,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Mobile Number",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.16,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("User Address",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displaywidth(context)*0.14,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Actions",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayheight(context)*0.69,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: searchUsersController.searchuserdata.length,
                        itemBuilder: (BuildContext context,int index){
                          var data=searchUsersController.searchuserdata[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: displaywidth(context)*0.08,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['id']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.08,
                                          child: const Center(
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage(Asset_Constant.logo),
                                                )
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.10,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SelectableText("${data['username']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.15,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: SelectableText("${data['email']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.10,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['phone']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.16,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${data['address']??""}",style: commonstyleweb(color: Colors.black),),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displaywidth(context)*0.14,
                                          child: Center(
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.eye,color: Colors.grey,size: 20,)),
                                                    IconButton(onPressed: (){
                                                      Map<String,dynamic> data=getallusersController.getallusersdata[index];
                                                      updateuserssidesheet(data:data);
                                                    }, icon: const Icon(CupertinoIcons.pen,color: Colors.grey,size: 20,)),
                                                    IconButton(onPressed: (){
                                                      // DeleteHub();
                                                    }, icon: const Icon(CupertinoIcons.delete,color: Colors.grey,size: 20,))
                                                  ],
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey.shade200,thickness: 0.5,)
                              ],
                            ),
                          );

                        }),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHeaderCell(String text, double widthFactor) {
    return SizedBox(
      width: displaywidth(context) * widthFactor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: commonstyleweb(color: Colors.black, weight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildRowCell(String text, double widthFactor, {bool isCircle = false}) {
    return SizedBox(
      width: displaywidth(context) * widthFactor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isCircle
              ? const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(Asset_Constant.logo),
          )
              : Text(
            text,
            style: commonstyleweb(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCell(int? id) {
    return SizedBox(
      width: displaywidth(context) * 0.30,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(CupertinoIcons.eye, color: Colors.grey, size: 15),
              // ),
              IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.pen, color: Colors.grey, size: 15),
              ),
              IconButton(
                onPressed: () {
                  DeleteHub(id ?? 1);
                },
                icon: const Icon(CupertinoIcons.delete,
                    color: Colors.grey, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class ChartData3 {
  ChartData3(this.x, this.y);
  final String x;
  final double y;
}

