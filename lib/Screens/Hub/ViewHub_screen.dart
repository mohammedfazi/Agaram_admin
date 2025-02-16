import 'package:agaram_admin/Screens/Orders/Vieworderhistory_screen.dart';
import 'package:pdf/widgets.dart'as pw;
import 'package:agaram_admin/Screens/Subscription/Viewsubscription_screen.dart';
import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:agaram_admin/common/Common%20color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../Service/GetByHubId/GetDeliverbyHubId.dart';
import '../../Service/GetByHubId/GetUsersByHubId.dart';
import '../../Service/GetByHubId/GetallOrdersbyHubId.dart';
import '../../Service/GetByHubId/GetallSubscriptionbyHubId.dart';
import '../../Service/Orders_Service/GetAdminallOrderByHubIdController.dart';
import '../../Widget/ShowDialog.dart';
import '../../common/Asset_Constant.dart';
import '../../common/common Size.dart';
import '../../common/common Textstyle.dart';


class ViewhubScreen extends StatefulWidget {
  final int id;
  final String hubname;
   ViewhubScreen({super.key,required this.id,required this.hubname});

  @override
  State<ViewhubScreen> createState() => _ViewhubScreenState();
}

class _ViewhubScreenState extends State<ViewhubScreen> {

  int ontapinsidehub=1;

  Future<Uint8List> _generatehubPDFnew(BuildContext context) async {
    try {
      // Fetch data
      await getAdminallOrdersByHubIdController.GetAdminAllOrderByHubIdApi(context,widget.id);
      // print("Fetched data: ${getallhubcontroller.getallhubdata}");
      if (getAdminallOrdersByHubIdController.getallorderdatabyhubid.isEmpty) {
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
                      "${widget.hubname} ",
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
                  headers: ['Product Name','Quantity','Total Pieces'],
                  headerStyle: pw.TextStyle(
                    fontSize: 15,
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data:getAdminallOrdersByHubIdController.getallorderdatabyhubid.map((data) {
                    return [
                      data['product']['productName']??"",
                      data['product']['stockQty']??"",
                      data['totalCount']??""+" Pieces",
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

  String formattedDate="";

  Future<List<dynamic>> fetchusersbyHubId() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1)); // Simulated delay
      return getUsersByHubIdcontroller.getallhubdata;
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> fetchdeliverybyHubId() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1)); // Simulated delay
      return getDeliveryByHubIdcontroller.getalldeliveryhubdata;
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }

  final GetUsersByHubIdcontroller getUsersByHubIdcontroller=Get.find<GetUsersByHubIdcontroller>();
  final GetDeliveryByHubIdcontroller getDeliveryByHubIdcontroller=Get.find<GetDeliveryByHubIdcontroller>();
  final GetOrderByHubIdcontroller getOrderByHubIdcontroller=Get.find<GetOrderByHubIdcontroller>();
  final GetSubscriptionByHubIdcontroller getSubscriptionByHubIdcontroller=Get.find<GetSubscriptionByHubIdcontroller>();
  final GetAdminallOrdersByHubIdController getAdminallOrdersByHubIdController=Get.find<GetAdminallOrdersByHubIdController>();


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
      "title":"Total Customers",
      "amount":"20"
    },
    {
      "icon":Icons.fact_check_sharp,
      "title":"Total Subscription",
      "amount":"20"
    },
  ];

  @override
  void initState() {
    getUsersByHubIdcontroller.GetUserByHubIdApi(context,widget.id);
    getDeliveryByHubIdcontroller.GetDeliveryByHubIdApi(context,widget.id);
    getOrderByHubIdcontroller.GetOrderByHubIdApi(context,widget.id);
    getSubscriptionByHubIdcontroller.GetSubscriptionByHubIdApi(context,widget.id);
    getAdminallOrdersByHubIdController.GetAdminAllOrderByHubIdApi(context,widget.id);

    DateTime data = DateTime.now();
    DateTime nextDay = data.add(const Duration(days: 1));
    String formattedDate1 = DateFormat('dd-MM-yyyy').format(nextDay);
    formattedDate=formattedDate1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("${widget.hubname.toUpperCase()} Hub Details",context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: displayheight(context)*0.20,
                width: double.infinity,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        mainAxisExtent: displayheight(context)*0.15,
                        crossAxisCount: 4),
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
                                      index==2?
                                      Obx(()=>
                                      getUsersByHubIdcontroller.getallhubdata.isEmpty?
                                      Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                          :
                                      Text("${getUsersByHubIdcontroller.getallhubdata.length}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                      index==1?
                                      Obx(()=>
                                      getDeliveryByHubIdcontroller.getalldeliveryhubdata.isEmpty?
                                      Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                          :
                                      Text("${getDeliveryByHubIdcontroller.getalldeliveryhubdata.length}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                      index==0?
                                      Obx(()=>
                                      getOrderByHubIdcontroller.getallorderhubdata.isEmpty?
                                      Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                          :
                                      Text("${getOrderByHubIdcontroller.getallorderhubdata.length}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
                                      index==3?
                                      Obx(()=>
                                      getSubscriptionByHubIdcontroller.getallsubscriptionhubdata.isEmpty?
                                      Text("0",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)
                                          :
                                      Text("${getSubscriptionByHubIdcontroller.getallsubscriptionhubdata.length}",style: commonstyle(color: Colors.black,size: 22,weight: FontWeight.w700),)):
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: displaywidth(context)*0.70,
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
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  ontapinsidehub=4;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:ontapinsidehub==4?Colors.white:Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Text("Subscription History",style: commonstyle(color: ontapinsidehub==4?Colors.black:Colors.white,size: 15,weight: FontWeight.w500),),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  ontapinsidehub=5;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:ontapinsidehub==5?Colors.white:Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Text("Today's Order",style: commonstyle(color: ontapinsidehub==5?Colors.black:Colors.white,size: 15,weight: FontWeight.w500),),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ontapinsidehub==5?
                    InkWell(
                      onTap: () async {
                        showloadingdialog(context);
                        await Printing.sharePdf(
                            bytes:await _generatehubPDFnew(context),
                            filename: "${widget.hubname} Order Details"
                        );
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color_Constant.secondarycolr,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.download_for_offline_outlined,
                                    color: Colors.white,),
                                  Text("EXPORT", style: commonstyle(),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ),
            ontapinsidehub==1?
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
                        height: displayheight(context) * 0.69,
                        width: double.infinity,
                        child: FutureBuilder<List<dynamic>>(
                          future: fetchusersbyHubId(), // Replace with your actual Future method
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Customers Not Found'));
                            } else {
                              // var allHubData = snapshot.data!;
                              return ListView.builder(
                                itemCount: getUsersByHubIdcontroller.getallhubdata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = getUsersByHubIdcontroller.getallhubdata[index];
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
                                                          backgroundImage:
                                                          AssetImage(Asset_Constant.logo),
                                                        )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: displaywidth(context) * 0.10,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SelectableText(
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
                                                      child: SelectableText(
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
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                CupertinoIcons.eye,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                // Map<String, dynamic> data = allHubData[index];
                                                                // updateuserssidesheet(data: data);
                                                              },
                                                              icon: const Icon(
                                                                CupertinoIcons.pen,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                // DeleteHub();
                                                              },
                                                              icon: const Icon(
                                                                CupertinoIcons.delete,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade200,
                                          thickness: 0.5,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ):
            ontapinsidehub==2?
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
                        height: displayheight(context) * 0.69,
                        width: double.infinity,
                        child: FutureBuilder<List<dynamic>>(
                          future: fetchdeliverybyHubId(), // Replace with your actual Future method
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Customers Not Found'));
                            } else {
                              // var allHubData = snapshot.data!;
                              return ListView.builder(
                                itemCount: getDeliveryByHubIdcontroller.getalldeliveryhubdata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = getDeliveryByHubIdcontroller.getalldeliveryhubdata[index];
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
                                                          backgroundImage:
                                                          AssetImage(Asset_Constant.logo),
                                                        )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: displaywidth(context) * 0.10,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SelectableText(
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
                                                      child: SelectableText(
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
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                CupertinoIcons.eye,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                // Map<String, dynamic> data = allHubData[index];
                                                                // updateuserssidesheet(data: data);
                                                              },
                                                              icon: const Icon(
                                                                CupertinoIcons.pen,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                // DeleteHub();
                                                              },
                                                              icon: const Icon(
                                                                CupertinoIcons.delete,
                                                                color: Colors.grey,
                                                                size: 20,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade200,
                                          thickness: 0.5,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ):
            ontapinsidehub==3?
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
                              ()=> getOrderByHubIdcontroller.getallorderhubdata.isEmpty?
                          const Center(
                            child: CupertinoActivityIndicator(),
                          )
                              :ListView.builder(
                              itemCount: getOrderByHubIdcontroller.getallorderhubdata.length,
                              itemBuilder: (BuildContext context,int index){
                                var data=getOrderByHubIdcontroller.getallorderhubdata[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                           Get.to(VieworderhistoryScreen(data:data));
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
            ):
            ontapinsidehub==4?
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
                                width: displaywidth(context)*0.12,
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
                                width: displaywidth(context)*0.08,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Assigned \nStatus",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),textAlign: TextAlign.center,),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.08,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Start Date",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: displaywidth(context)*0.08,
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
                              ()=> getSubscriptionByHubIdcontroller.getallsubscriptionhubdata.isEmpty?
                          const Center(
                            child: CupertinoActivityIndicator(),
                          )
                              :ListView.builder(
                              itemCount: getSubscriptionByHubIdcontroller.getallsubscriptionhubdata.length,
                              itemBuilder: (BuildContext context,int index){
                                var data=getSubscriptionByHubIdcontroller.getallsubscriptionhubdata[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          setState(() {
                                            Map<String,dynamic>data1=data;
                                            Get.to(ViewsubscriptionScreen(data: data1));
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
                                                  width: displaywidth(context)*0.12,
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
                                                  width: displaywidth(context) * 0.08,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: data['hubuserId'] == null ? Colors.red.shade100 : Colors.green.shade100,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: data['hubuserId'] == null
                                                              ? Text("Not Assigned", style: commonstyleweb(color: Colors.red,weight: FontWeight.w600,size: 12))
                                                              : Text("Assigned", style: commonstyleweb(color: Colors.green,weight: FontWeight.w600,size:12)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: displaywidth(context)*0.08,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("${data['startDate']??""}",style: commonstyleweb(color: Colors.black),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: displaywidth(context)*0.08,
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

                                                            }, icon: const Icon(Icons.edit_outlined,color: Colors.grey,size: 20,)),
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
            ):
            ontapinsidehub==5?
            SizedBox(
              // height: displayheight(context)*1,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(" Today's Order  -  $formattedDate",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: displayheight(context)*1,
                      width: double.infinity,
                      child: getAdminallOrdersByHubIdController.getallorderdatabyhubid.isEmpty?
                      Center(
                          child:Text("Tomorrow's's Order Not Found",style: commonstyle(color: Colors.black,size:15,),)
                      )
                          :GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 2.0,
                              crossAxisSpacing: 2.0,
                              mainAxisExtent: displayheight(context)*0.18,
                              crossAxisCount: 4),
                          itemCount: getAdminallOrdersByHubIdController.getallorderdatabyhubid.length,
                          itemBuilder: (BuildContext context,int index){
                            var data=getAdminallOrdersByHubIdController.getallorderdatabyhubid[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    // index==0?
                                    // container=6:
                                    // index==1?
                                    // container=3:
                                    // index==2?
                                    // container=4:
                                    // index==3?
                                    // container=6:
                                    // index==4?
                                    // container=14:
                                    // index==5?
                                    // container=5:
                                    // container=1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Row(
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
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ImageNetwork(
                                                    image: "${data['product']['productImages']}",
                                                    height: 230,
                                                    width: 80,
                                                    duration: 1,
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
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:18.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("${data['product']['productName']??""} (${data['product']['stockQty']??""})",style: commonstyle(color: Colors.grey.shade600,size: 12),),
                                                Text("${data['totalCount']??""} Pieces",style: commonstyle(color: Colors.black,size: 15,weight: FontWeight.w700),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                  ),
                ],
              ),
            ):
                Container()
          ],
        ),
      ),
    );
  }
}
