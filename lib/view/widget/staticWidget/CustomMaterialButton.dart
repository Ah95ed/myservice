import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/Models/constant/Constant.dart';
import 'package:flutter/material.dart';


class CustomMaterialButton extends StatelessWidget {
  String? title;

  CustomMaterialButton({
    super.key,
    required this.title,
    required this.onPressed,
  });
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(1),
        vertical: getheight(2),
      ),
      child: MaterialButton(
        height: getheight(6),
        minWidth: getWidth(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: ColorUsed.PrimaryBackground, // Border color
            width: 1.0, // Border width
          ),
        ),
        color: ColorUsed.second,
        onPressed: onPressed,
        child: Text(
          title!,
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
