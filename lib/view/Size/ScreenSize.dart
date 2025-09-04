import 'dart:math';
import 'package:Al_Zab_township_guide/view/Size/SizeBuilder.dart';
import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  double get screenHeight => isLandscape
      ? MediaQuery.sizeOf(this).width
      : MediaQuery.sizeOf(this).height;

  double get screenWidth => isLandscape
      ? MediaQuery.sizeOf(this).height
      : MediaQuery.sizeOf(this).width;

  SizeBuilder get sizeBuilder => SizeBuilder.of(this);
  double get scaleWidth => sizeBuilder.width / sizeBuilder.baseSize.width;
  double get scaleHeight => sizeBuilder.height / sizeBuilder.baseSize.height;

  // ! this to calculate height screen part from 100;
  double getHeight(num h) {
    return h * scaleHeight;
  }

  // ! this to calculate width screen part from 100;
  double getWidth(num w) {
    return w * scaleWidth;
  }

  // ! here to return font size in all screen

  double getFontSize(num f) {
    return f * scaleWidth;
  }

  double getMinSize(num f) {
    return f * min(scaleWidth, scaleHeight);
  }
}
