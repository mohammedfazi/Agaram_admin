import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:flutter/material.dart';

import '../../common/Common color.dart';
import '../../common/common Size.dart';
import '../../common/common Textstyle.dart';
class ApproveDriverScreen extends StatefulWidget {

  final Map<String,dynamic> data;
   ApproveDriverScreen({super.key,required this.data});

  @override
  State<ApproveDriverScreen> createState() => _ApproveDriverScreenState();
}

class _ApproveDriverScreenState extends State<ApproveDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("View Driver Profile", context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Delivery Partner Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
              ),
              widget.data==null?
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Driver Profile Not Found",style: commonstyle(size:15,weight: FontWeight.w700,color: Colors.black),),
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
                                    Text("${widget.data['username']??""}",style: commonstyle(color: Colors.black,size: 15),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text("Driver Email ID : ",style: commonstyle(weight: FontWeight.w700,color: Colors.black,size: 15),),
                                    Text("${widget.data['email']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                    Text("${widget.data['phone']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                                Text("${widget.data['address']??""}",style: commonstyle(color: Colors.black,size: 15),)
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
                child: Text("Delivery Partner Document Details",style: commonstyle(size: 18,weight: FontWeight.w700,color: Color_Constant.primarycolr),),
              ),
              Center(
                child: SizedBox(
                  width: displaywidth(
                      context) *
                      0.21,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child: InkWell(
                          onTap: () {

                          },
                          child:
                          Container(
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  5),
                              color: Colors
                                  .white,
                            ),
                            child:
                            Padding(
                              padding:
                              const EdgeInsets
                                  .all(
                                  8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .check,
                                    color: Colors
                                        .green
                                        .shade800,
                                    size:
                                    20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(
                                        left: 8.0),
                                    child: Text(
                                        "Approve",
                                        style: commonstyleweb(
                                            color: Colors
                                                .green
                                                .shade800,
                                            weight: FontWeight
                                                .w600)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child: InkWell(
                          onTap: () {

                          },
                          child:
                          Container(
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  5),
                              color: Colors
                                  .white,
                            ),
                            child:
                            Padding(
                              padding:
                              const EdgeInsets
                                  .all(
                                  8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                                children: [
                                  Icon(
                                    Icons
                                        .close,
                                    color: Colors
                                        .red
                                        .shade800,
                                    size:
                                    20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .only(
                                        left: 8.0),
                                    child: Text(
                                        "Cancelled",
                                        style: commonstyleweb(
                                            color: Colors
                                                .red
                                                .shade800,
                                            weight: FontWeight
                                                .w600)),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
