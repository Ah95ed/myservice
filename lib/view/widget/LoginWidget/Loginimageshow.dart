import 'package:Al_Zab_township_guide/view/configSize/SizeConfig.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Login_Image extends StatelessWidget {
  const Login_Image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.screenHeight * 0.12,
              ),
              height: SizeConfig.screenHeight * 0.15,
              child: Image.asset(
                "assets/asd.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
