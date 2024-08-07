import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';

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
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            blurRadius: 4,
            color: ColorUsed.primary,
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
      
          height: getheight(12),
          child: Image.asset(
            "assets/asd.png",
          ),
        ),
      ),
    );
  }
}
