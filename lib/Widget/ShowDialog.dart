import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showloadingdialog(BuildContext context){
  showDialog(context: context, builder: (BuildContext context){
    return const AlertDialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      content: Center(
        child:CupertinoActivityIndicator(
          color: Colors.white,
        ) ,
      ),
    );
  });
}