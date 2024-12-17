import 'package:flutter/material.dart';

Size displaySize(BuildContext context){
return MediaQuery.of(context).size;
}

double displayheight(BuildContext context){
  return displaySize(context).height;
}
double displaywidth(BuildContext context){
  return displaySize(context).width;
}
