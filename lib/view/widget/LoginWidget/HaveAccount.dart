import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({this.s1, this.s2, super.key, this.route});

  final String? s1, s2, route;
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
        SizedBox(width: getWidth(1.0)),
        TextButton(
          autofocus: true,
          onPressed: () => {read.managerScreenSplash(route!, context, false)},
          child: Text(
            s2!,
            style: TextStyle(
              color: ColorUsed.second,
              fontWeight: FontWeight.bold, // Color(0xFF501063),
            ),
          ),
        ),
      ],
    );
  }
}
