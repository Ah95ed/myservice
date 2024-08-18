import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/EditScreen/CustomDialog.dart';
import 'package:Al_Zab_township_guide/view/screens/LineScreen/LineScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customdrawer extends StatelessWidget {
  Customdrawer({super.key});

  //! need controller Drawer Page

  @override
  Widget build(BuildContext context) {
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
                Scaffold.of(context).closeDrawer();
                // context.read<Providers>().refresh();
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
            leading: Icon(
              Icons.delete,
              color: Colors.red.shade700,
            ),
            title: Text(
              Translation[Language.delete_account],
              style: TextStyle(
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700,
              ),
            ),
            onTap: () {
              Scaffold.of(context).closeDrawer();

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
            title: Text(Translation['settings']),
            onTap: () {},
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
              Scaffold.of(context).closeDrawer();
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return CustomDialog();
              //     },
              //   );
              if (shared!.getBool('isRegister') == true) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return CustomDialogAddService();
                    });
                // showCupertinoBottomReuse(
                //   context,
                //   actions: [
                //     CupertinoActionSheetAction(
                //       child: Text(
                //         S.current.doctor,
                //         style: TextStyle(
                //           fontSize: setFontSize(14),
                //           fontWeight: FontWeight.bold,
                //           color: ColorUsed.second,
                //         ),
                //       ),
                //       onPressed: () {},
                //     ),
                //     CupertinoActionSheetAction(
                //       child: Text(
                //         S.current.blood_donation,
                //         style: TextStyle(
                //           fontSize: setFontSize(14),
                //           fontWeight: FontWeight.bold,
                //           color: ColorUsed.second,
                //         ),
                //       ),
                //       onPressed: () {},
                //     ),
                //     CupertinoActionSheetAction(
                //       child: Text(
                //         Translation[Language.cars],
                //         style: TextStyle(
                //           fontSize: setFontSize(14),
                //           fontWeight: FontWeight.bold,
                //           color: ColorUsed.second,
                //         ),
                //       ),
                //       onPressed: () {
                //         read.managerScreen(LineScreen.Route, context);
                //       },
                //     ),
                //     CupertinoActionSheetAction(
                //       child: Text(
                //         S.current.professions,
                //         style: TextStyle(
                //           fontSize: setFontSize(14),
                //           fontWeight: FontWeight.bold,
                //           color: ColorUsed.second,
                //         ),
                //       ),
                //       onPressed: () {},
                //     ),
                //     CupertinoActionSheetAction(
                //       child: Text(
                //         S.current.internal_transfer,
                //         style: TextStyle(
                //           fontSize: setFontSize(14),
                //           fontWeight: FontWeight.bold,
                //           color: ColorUsed.second,
                //         ),
                //       ),
                //       onPressed: () {},
                //     ),
                //   ],
                //   title: S.current.select_service,
                //   // message: '---------  ----------',
                // );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Translation[Language.register_first],
                    ),
                  ),
                );
                //  Navigator.of(context).pop();
              }
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
                Translation[Language.team_policy],
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

  Future<void> showCustomBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      height: 5,
                      width: 40,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.share, color: Colors.blue),
                      title: Text('Share'),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle share action
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.link, color: Colors.green),
                      title: Text('Get link'),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle get link action
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.orange),
                      title: Text('Edit name'),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle edit name action
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete collection'),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle delete action
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CustomDialogAddService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          Translation[Language.select_service],
          style: TextStyle(
            fontSize: setFontSize(16),
            fontWeight: FontWeight.bold,
            color: ColorUsed.DarkGreen,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: getheight(0.2),
            color: ColorUsed.DarkGreen,
          ),
          SizedBox(
            height: getheight(1),
          ),
          ButtonDialogAddService(
            () {
              context.read<Providers>().managerScreen(
                    LineScreen.Route,
                    context,
                  );
            },
            Translation[Language.line],
          ),
          SizedBox(
            height: getheight(1),
          ),
          Divider(),
          SizedBox(
            height: getheight(1),
          ),
          ButtonDialogAddService(
            () {},
            Translation[Language.professions],
          ),
          SizedBox(
            height: getheight(1),
          ),
          Divider(),
          SizedBox(
            height: getheight(1),
          ),
          ButtonDialogAddService(
            () {},
            Translation[Language.professions],
          ),
          SizedBox(
            height: getheight(1),
          ),
          Divider(),
          SizedBox(
            height: getheight(1),
          ),
          ButtonDialogAddService(
            () {},
            Translation[Language.professions],
          ),
          SizedBox(
            height: getheight(1),
          ),
          Divider(),
          SizedBox(
            height: getheight(1),
          ),
          ButtonDialogAddService(
            () {
              Logger.logger('message tjis this');
            },
            Translation[Language.professions],
          ),
        ],
      ),
    );
  }
}

class ButtonDialogAddService extends StatelessWidget {
  ButtonDialogAddService(
    this.onPressd,
    this.title, {
    super.key,
  });
  String? title;
  Function()? onPressd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressd,
        child: Container(
          child: Center(
            child: Text(
              title!,
              style: TextStyle(
                fontSize: setFontSize(14),
                color: ColorUsed.DarkGreen,
                fontWeight: FontWeight.bold,
                decorationThickness: 2,
              ),
            ),
          ),
          width: getWidth(100),
          height: getheight(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.notWhite.withOpacity(0.3),
            boxShadow: [
              BoxShadow(
                color: ColorUsed.primary.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ));
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
}

Future<Type?> showCupertinoBottomReuse(
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
          child: Text(Translation[Language.cancel]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}

Future<void> showAlertDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Translation[Language.select_service],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomMaterialButton(
                title: Translation[Language.add_service],
                onPressed: () async {
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
    },
  );
}
