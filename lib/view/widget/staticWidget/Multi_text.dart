import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';

class MultiText extends StatelessWidget {
  String str, con;
  MultiText(this.str, this.con, {super.key});

  // const MultiText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(2),
        vertical: getheight(4),
      ),
      child: Row(
        children: [
          SizedBox(
            height: getheight(1),
          ),
          Expanded(
            flex: 0,
            child: Text(
              con,
              style: TextStyle(
                  fontSize: setFontSize(14),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: getWidth(2),
          ),
          Expanded(
            flex: 2,
            child: Text(
              str,
              style: TextStyle(
                  fontSize: setFontSize(14),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: getheight(2),
          ),
        ],
      ),
    );
  }
}
