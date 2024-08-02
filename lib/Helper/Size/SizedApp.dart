import 'package:Al_Zab_township_guide/main.dart';
import 'package:flutter/material.dart';


// حتى احسب الجزء من مئة حجم الشاشة الكلي
double getheight(double height) {
  return MediaQuery.of(MyApp.getContext()!).size.height * height / 100;
}

double getWidth(double width) {

  return MediaQuery.of(MyApp.getContext()!).size.width * width / 100;
}
  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
 double setFontSize(double fontSize) {
    return (MediaQuery.of(MyApp.getContext()!).size.width/ 3) * fontSize / 100;
  }
