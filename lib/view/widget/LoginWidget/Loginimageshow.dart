

import 'package:Al_Zab_township_guide/generated/l10n.dart';
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
              offset: Offset(0, 2),
              blurRadius: 4,
              color: Color.fromARGB(255, 158, 158, 158),
            )
          ],
        color: ColorUsed.primary, // Color(0xFF501063),
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
              margin:  EdgeInsets.only(top: 10.h),
              height: 15.h,
              child: Image.asset(
                "assets/asd.png",
              ),
            ),
            Container(
              margin:  EdgeInsets.symmetric(
                horizontal:4.w,
                vertical: 5.h,
              ),
              alignment: Alignment.bottomRight,
              child: Text(
                S.of(context).login,
                style:  TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}