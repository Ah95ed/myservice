import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customdrawer extends StatelessWidget {
  Customdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Drawer(
      // backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.symmetric(
                vertical: getheight(2), horizontal: getheight(2)),
            duration: Duration(milliseconds: 2000),
            decoration: BoxDecoration(
              color: ColorUsed.primary,
            ),
            child: Text(
              S.current.more_options,
              style: TextStyle(
                fontSize: setFontSize(16),
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text(
              S.current.register_now,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              // Navigator.pop(context);
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            title: Text(
              S.current.login,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {},
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            title: Text(
              S.current.edit_Data,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              // here to open edit Screen
              // read.managerScreen(, context)
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            title: Text(S.current.settings),
            onTap: () {},
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            title: Text(
              S.current.whocandonate,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              read.launchInBrowser(Uri.parse(Constant.Link));
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getheight(20),
              horizontal: getWidth(6),
            ),
            child: ListTile(
              title: Text(
                S.current.team_policy,
                style: TextStyle(
                  fontSize: setFontSize(10),
                  fontWeight: FontWeight.w400,
                  color: ColorUsed.DarkGreen,
                ),
              ),
              onTap: () {
                //https://github.com/Alqdees/private/blob/main/index.html
                read.launchInBrowser(Uri.parse(Constant.PrivacyPolicy));
              },
            ),
          ),
        ],
      ),
    );
  }
}
