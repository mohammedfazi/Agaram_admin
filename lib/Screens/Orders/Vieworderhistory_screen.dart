import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../common/Common color.dart';
import '../../common/common Size.dart';
import '../../common/common Textstyle.dart';

class VieworderhistoryScreen extends StatefulWidget {
  Map<String,dynamic> data;
   VieworderhistoryScreen({super.key,required this.data});

  @override
  State<VieworderhistoryScreen> createState() => _VieworderhistoryScreenState();
}

class _VieworderhistoryScreenState extends State<VieworderhistoryScreen> {
  @override
  Widget build(BuildContext context) {
    List getproductdata=widget.data['products']??[];
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("View Checkout Details - ( ${widget.data['orderId']??""} )"),
      body:  Padding(
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
                                    Text("${widget.data['orderId']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Payment Id : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                    Text("${widget.data['paymentId']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                    Text("${widget.data['paymentType']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Total Amount  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                    Text("Rs : ${widget.data['totalPrice']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                    Text("Payment Status  : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                    Text("${widget.data['paymentStatus']??""}",style: commonstyle(color: widget.data['paymentStatus']=="PENDING"?Colors.red:widget.data['paymentStatus']=="COMPLETED"?Colors.green:Colors.orange,size: 15,weight: FontWeight.w700),)
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
                  child: Text("Order Not Assigned To Driver",style: commonstyle(size:15,weight: FontWeight.w700,color: Colors.black),),
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
                  child: Text("Order  Not Assigned To Hub",style: commonstyle(size:15,weight: FontWeight.w700,color: Colors.black),),
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
              SizedBox(
                  // height:displayheight(context)*0.50,
                  width:double.infinity,
                  child:getproductdata.isEmpty?
                  Center(
                    child: Text("Order Products Not Found",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                  )
                      :GridView.builder(
                    shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: getproductdata.length,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        mainAxisExtent: displayheight(context)*0.20,
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("No.of.Pieces : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                              Text("${getproductdata[index]['checkoutproduct']['qquantity']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
    );
  }
}
