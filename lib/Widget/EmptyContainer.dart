import 'package:flutter/material.dart';

import '../common/Asset_Constant.dart';
import '../common/common Size.dart';
import '../common/common Textstyle.dart';

Widget EmptyContainer(BuildContext context,txt){
  return   Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(Asset_Constant.empty,height: displayheight(context)*0.25,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$txt",style: commonstyleweb(color: Colors.black,weight: FontWeight.w600)),
      ),
    ],
  );
}