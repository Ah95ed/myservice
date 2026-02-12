import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';

class MultiText extends StatelessWidget {
  const MultiText(this.str, this.con, {super.key});

  final String str, con;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(2),
          vertical: getheight(0.1),
        ),
        child: Row(
          children: [
            Text(
              con,
              style: TextStyle(
                fontSize: setFontSize(14),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: getWidth(2)),
            Text(
              str,
              style: TextStyle(
                fontSize: setFontSize(14),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
