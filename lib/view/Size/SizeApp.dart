

import 'package:sizer/sizer.dart';

class SizeApp {
  SizeApp({required this.height, required this.width});
   double height = 0.0;
   double width = 0.0;
 double get gheight => height *  SizerUtil.height / 100;
  double get gwidth => width *  SizerUtil.width / 100;

}