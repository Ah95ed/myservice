import 'package:Al_Zab_township_guide/main.dart';
import 'package:flutter/material.dart';

bool get isLandScape =>
    MediaQuery.of(MyApp.getContext()!).orientation == Orientation.landscape;
double get screenWidth => isLandScape
    ? MediaQuery.of(MyApp.getContext()!).size.height
    : MediaQuery.of(MyApp.getContext()!).size.width;

double get screenHeight => isLandScape
    ? MediaQuery.of(MyApp.getContext()!).size.width
    : MediaQuery.of(MyApp.getContext()!).size.height;

// حتى احسب الجزء من مئة حجم الشاشة الكلي
double getheight(double height) {
  return screenHeight * height / 100;
}

double getWidth(double width) {
  return screenWidth * width / 100;
}

/// Calculates the sp (Scalable Pixel) depending on the device's screen size
double setFontSize(double fontSize) {
  return (screenWidth / 3) * fontSize / 100;
}
