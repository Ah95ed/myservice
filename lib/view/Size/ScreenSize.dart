import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenSize on BuildContext {
  bool get isLandscape => ScreenUtil().orientation == Orientation.landscape;

  double get screenHeight => ScreenUtil().screenHeight;

  double get screenWidth => ScreenUtil().screenWidth;

  // ! this to calculate height screen part from 100;
  double getHeight(num h) {
    return h.h;
  }

  // ! this to calculate width screen part from 100;
  double getWidth(num w) {
    return w.w;
  }

  // ! here to return font size in all screen

  double getFontSize(num f) {
    return f.sp;
  }

  double getMinSize(num f) {
    return min(f.w, f.h);
  }
}
