import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:flutter/material.dart';

/// حقل نصي مشترك يُستخدم في جميع شاشات التطبيق
/// متوافق مع نظام الألوان الموحّد للشاشة الرئيسية
class SharedAuthTextField extends StatelessWidget {
  const SharedAuthTextField(
    this.controller,
    this.icon,
    this.hintText,
    this.isPassword,
    this.isEmail, {
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData? icon;
  final String? hintText;
  final bool? isPassword;
  final bool? isEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getheight(7.5),
      width: getWidth(90),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ColorUsed.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ?? false,
        keyboardType: (isEmail ?? false)
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: TextStyle(color: ColorUsed.DarkGreen, fontSize: setFontSize(15)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorUsed.primary.withOpacity(0.7)),
          hintText: hintText,
          hintStyle: TextStyle(
            color: ColorUsed.primary.withOpacity(0.4),
            fontSize: setFontSize(14),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorUsed.primary.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorUsed.second, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

