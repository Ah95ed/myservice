import 'package:Al_Zab_township_guide/main.dart';
import 'package:flutter/material.dart';



double getHight(double height) {
 return MediaQuery.of(MyApp.getContext()!).size.height * height/100;
}
double getWidth(double width) {
  return MediaQuery.of(MyApp.getContext()!).size.width * width/100;
}