import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool get isLandScape => ScreenUtil().orientation == Orientation.landscape;
double get screenWidth => ScreenUtil().screenWidth;
double get screenHeight => ScreenUtil().screenHeight;

// حتى احسب الجزء من مئة حجم الشاشة الكلي
double getheight(double height) {
  return screenHeight * height / 100;
}

double getWidth(double width) {
  return screenWidth * width / 100;
}

/// Calculates the sp (Scalable Pixel) depending on the device's screen size
double setFontSize(double fontSize) {
  return fontSize.sp;
}
