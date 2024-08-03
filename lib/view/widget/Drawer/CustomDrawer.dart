import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';

class Customdrawer extends StatelessWidget {
   Customdrawer({super.key});
  

  @override
  Widget build(BuildContext context) {

    return Drawer(
   
      // backgroundColor: Colors.white,
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          duration: Duration(milliseconds: 2000),
          decoration: BoxDecoration(
            color: ColorUsed.primary,
            border: Border.all(
              width: getWidth(0.2),
              color: ColorUsed.DarkGreen,
            ),
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(
              fontSize: setFontSize(18),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        ListTile(
          title: const Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(MyApp.getContext()!);
          },
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {},
        ),
      ]),
    );
  }
}
