import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HaveAccount extends StatelessWidget {
   HaveAccount({
    this.s1,
    this.s2,
    super.key,  this.route,
  });
  String? s1, s2,route;
  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          s1!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorUsed.DarkGreen,
          ),
        ),
        SizedBox(
          width: 0.1.w,
        ),
        TextButton(
          autofocus: true,
          onPressed: () =>
              {read.managerScreenSplash(route!, context,false)},
          child: Text(
           s2!,
            style: TextStyle(
                color: ColorUsed.second,
                fontWeight: FontWeight.bold // Color(0xFF501063),
                ),
          ),
        ),
      ],
    );
  }
}
