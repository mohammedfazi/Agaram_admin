import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import '../../Service/Subscription_Service/Getseprate_Subscription_Controller.dart';
import '../../common/Common color.dart';
import '../../common/common Size.dart';
import '../../common/common Textstyle.dart';
import 'package:get/get.dart';

class ViewsubscriptionScreen extends StatefulWidget {
  Map<String,dynamic>data;
  // Map<String,dynamic>subscriptiondata;
   ViewsubscriptionScreen({super.key,required this.data});

  @override
  State<ViewsubscriptionScreen> createState() => _ViewsubscriptionScreenState();
}

class _ViewsubscriptionScreenState extends State<ViewsubscriptionScreen> {

  final GetSepratedateController getSepratedateController=Get.find<GetSepratedateController>();

  @override
  void initState() {
    getSepratedateController.GetSeprateDateApi(context,widget.data['id']);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("View Subscription - ( ${widget.data['subscriptionOrderId']??""} )",context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
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
                                      Text("${widget.data['subscriptionOrderId']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Total Order Days : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['totalDate']??""} Days",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("${widget.data['startDate']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Subscription End Date  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['endDate']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("${widget.data['preference']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Subscription Status  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['status']??""}",style: commonstyle(color: widget.data['status']=="PENDING"?Colors.red:widget.data?['status']=="COMPLETED"?Colors.green:Colors.orange,size: 15,weight: FontWeight.w700),)
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
                                      Text("Total Subscription Amount : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("₹ ${widget.data['totalPrice']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),

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



            (widget.data['deliverystatuses'] != null && widget.data['deliverystatuses'].isNotEmpty)
                ? SizedBox(
              width: double.infinity,
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 80,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      crossAxisCount: 3),
                  itemCount: widget.data['deliverystatuses'].length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = widget.data['deliverystatuses'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        child: ListTile(
                          trailing: Text(data[index]['deliveryDate'] ?? '', style: txtfieldbold),
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
            )
                : Center(
              child: Text(
                "Subscription History Not Found",
                style: commonstyle(color: Colors.black),
              ),
            ),

            Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Customer Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
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
                                      Text("${widget.data['user']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Customer Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['user']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("${widget.data['user']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                  Text("${widget.data['user']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                  child: Text("Delivery Partner Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                ),
                widget.data['deliveryuser']==null?
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Subscription Is Not Assigned To Driver",style: commonstyle(size:15,weight: FontWeight.w700,color: Colors.black),),
                  ),
                )
                    :Padding(
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
                                      Text("Driver Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['deliveryuser']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Driver Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['deliveryuser']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("Driver Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['deliveryuser']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                  Text("Driver Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                  Text("${widget.data['deliveryuser']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                  child: Text("Hub Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
                ),
                widget.data['hubuser']==null?
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Subscription Is Not Assigned To Hub",style: commonstyle(size:15,weight: FontWeight.w700,color: Colors.black),),
                  ),
                )
                    :Padding(
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
                                      Text("Hub Name : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['hubuser']['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Hub Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['hubuser']['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("Hub Mobile Number : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['hubuser']['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                  Text("Hub Address : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                  Text("${widget.data['hubuser']['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                            image: "${widget.data['product']['productImages']}",
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
                                          Text("${widget.data['product']['productName']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:20.0),
                                        child: Row(
                                          children: [
                                            Text("Product Price : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                            Text("${widget.data['product']['price']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                      Text("${widget.data['product']['stockQty']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Product Quantity Per Day : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                      Text("${widget.data['quantity']??""} Pieces",style: commonstyle(color: Colors.black,size: 15),)
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
        ),
      ),
    );
  }
}
