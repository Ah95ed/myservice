import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Login_Image extends StatelessWidget {
   Login_Image({
    this.height,
    super.key,
  });
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(90),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            color: Colors.white54,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            ColorUsed.primary,
            ColorUsed.second,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
      
          height: 15.h,
          child: Image.asset(
            "assets/asd.png",
          ),
        ),
      ),
    );
  }
}
