import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../common/Common color.dart';
import '../../common/common Textstyle.dart';

class HubstocksScreen extends StatefulWidget {
  final Map<String,dynamic> data;
   HubstocksScreen({super.key,required this.data});

  @override
  State<HubstocksScreen> createState() => _HubstocksScreenState();
}

class _HubstocksScreenState extends State<HubstocksScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("${widget.data['hubuser']['username']??"".toUpperCase()} STOCKS",
          context),
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
                  child: Text("Stock Product Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
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
