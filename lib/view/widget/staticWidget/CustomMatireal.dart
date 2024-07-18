import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomMaterialButton extends StatelessWidget {
  String? title;

  CustomMaterialButton({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 1.0.w,
        vertical: 1.0.w,
      ),
      child: MaterialButton(
        height: 6.h,
        minWidth: 40.w,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          // side: const BorderSide(
          //   color: Colors.black, // Border color
          //   width: 1.0, // Border width
          // ),
        ),
        color: ColorUsed.second,
        onPressed: () {},
        child:  Text(
          title!,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}

// class CustomButton extends StatelessWidget {
//   final String text;
//   final Color backgroundColor;
//   final Color textColor;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;
//   final VoidCallback onPressed;

//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.backgroundColor,
//     required this.textColor,
//     required this.borderRadius,
//     required this.padding,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: padding,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 16.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TableNameColumn extends StatelessWidget {
//   TableNameColumn({super.key, required this.name});
//   final String name;
//   final hi = Get.height;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: hi * 0.04,
//       color: ColorUsed.whitesoft,
//       alignment: Alignment.center,
//       child: Center(
//         child: Text(
//           name,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
