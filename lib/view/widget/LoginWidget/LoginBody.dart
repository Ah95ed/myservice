
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.text,
    required this.keyboardType,
    required this.icon,
  });
  final TextInputType? keyboardType;
  final TextEditingController? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 0.1.h,
          horizontal: 2.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            50,
          ),
          color: Colors.grey[200],
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 0.01,
              color: ColorUsed.primary,
            )
          ],
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: text,
          keyboardType: TextInputType.emailAddress,
          cursorColor: ColorUsed.primary, //Color(0xFF501063),
          decoration: InputDecoration(
              icon: Icon(
                icon,
                color: ColorUsed.primary, //Color(0xFF501063),
              ),
              hintText: S.of(context).enter_email,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none),
        ),
      ),
    );
  }
}
