import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/EditScreen/CustomDialog.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/WhoCanDonateScreen%20.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customdrawer extends StatelessWidget {
  Customdrawer({super.key});
  late BuildContext ctx;

  //! need controller Drawer Page

  @override
  Widget build(BuildContext context) {
    this.ctx = context;
    final read = context.read<Providers>();
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: getheight(20),
            color: ColorUsed.primary,
            padding: EdgeInsets.all(12),
            child: shared!.getString('nameUser') == null
                ? Text(
                    S.of(context).more_options,
                    style: TextStyle(
                      fontSize: setFontSize(16),
                      fontWeight: FontWeight.w500,
                      color: AppTheme.nearlyWhite,
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        shared!.getString('nameUser') ?? '',
                        style: TextStyle(
                          fontSize: setFontSize(15),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.notWhite,
                        ),
                      ),
                      SizedBox(
                        height: getheight(0.5),
                      ),
                      Text(
                        shared!.getString('emailUser') ?? '',
                        style: TextStyle(
                          fontSize: setFontSize(15),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.notWhite,
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(
            height: getheight(0.2),
          ),
          ListTile(
            leading: shared!.getBool('isRegister') == true
                ? Icon(Icons.exit_to_app)
                : Icon(Icons.app_registration),
            title: shared!.getBool('isRegister') == true
                ? Text(
                    S.of(context).exit,
                    style: TextStyle(
                      fontSize: setFontSize(12),
                      fontWeight: FontWeight.w500,
                      color: ColorUsed.DarkGreen,
                    ),
                  )
                : Text(
                    S.of(context).register_now,
                    style: TextStyle(
                      fontSize: setFontSize(12),
                      fontWeight: FontWeight.w500,
                      color: ColorUsed.DarkGreen,
                    ),
                  ),
            onTap: () {
              if (shared!.getBool('isRegister') == true) {
                shared!.remove('nameUser');
                shared!.remove('emailUser');
                shared!.remove('phoneUser');
                shared!.remove('isRegister');
                Scaffold.of(ctx).closeDrawer();
                context.read<Providers>().refresh();
              } else {
                read.managerScreen(SignupScreen.Route, context);
              }
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              S.of(context).edit_Data_and_delete,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              Scaffold.of(ctx).closeDrawer();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog();
                },
              );
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () {},
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(
              S.of(context).whocandonate,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              read.managerScreen(WhoCanDonateScreen.route, context);
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              S.of(context).add_service,
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: ColorUsed.DarkGreen,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              BottomSheets.showCupertinoBottomReuse(
                context,
                actions: [
                  CupertinoActionSheetAction(
                    child: Text(S.current.doctor),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    child: Text(S.current.blood_donation),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    child: Text(S.current.Cars),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    child: Text(S.current.professions),
                    onPressed: () {},
                  ),
                  CupertinoActionSheetAction(
                    child: Text(S.current.internal_transfer),
                    onPressed: () {},
                  ),
                ],
                title: S.current.Select_Service,
                // message: '---------  ----------',
              );
            },
          ),
          Divider(
            thickness: getWidth(0.5),
            color: ColorUsed.DarkGreen,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: getheight(2),
              horizontal: getWidth(8),
            ),
            child: ListTile(
              title: Text(
                S.of(context).team_policy,
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

class BottomSheets {
  /// show modal bottom sheet
  static Future<Type?> showModalBottomReuse(
    BuildContext context, {
    required Widget child,
  }) {
    return showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title
            const SizedBox(height: 20),
            const Text('This is a bottom sheet'),
            const Divider(),

            Container(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ],
        );
      },
    );
  }

  /// show cupertino bottom sheet
  static Future<Type?> showCupertinoBottomReuse(
    BuildContext context, {
    required List<Widget> actions,
    required String title,
    // required String message,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            title,
            style: TextStyle(
              fontSize: setFontSize(15),
              fontWeight: FontWeight.bold,
              color: ColorUsed.DarkGreen,
            ),
          ),
          // message: Text(message),
          actions: actions,
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
