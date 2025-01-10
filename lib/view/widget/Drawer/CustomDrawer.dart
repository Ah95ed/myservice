import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/EditScreen/CustomDialog.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Customdrawer extends StatelessWidget {
  const Customdrawer({super.key});

  //! need controller Drawer Page

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: getheight(20),
              color: ColorUsed.primary,
              child: shared!.getString('nameUser') == null
                  ? Center(
                    child: Text(
                        Translation[Language.more_options],
                        style: TextStyle(
                          fontSize: setFontSize(16),
                          fontWeight: FontWeight.w500,
                          color: AppTheme.nearlyWhite,
                        ),
                      ),
                  )
                  : Center(
                    child: Column(
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
                  // read.refresh();
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
              leading: Icon(Icons.share),
              title: Text(Translation[Language.share_app]),
              onTap: () async {
                Scaffold.of(context).closeDrawer();
      
                await Share.share(
                  'https://play.google.com/store/apps/details?id=com.Blood.types',
                  subject: 'رابط التطبيق على كوكل بلي',
                );
              },
            ),
            Divider(
              thickness: getWidth(0.5),
              color: ColorUsed.DarkGreen,
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text(Translation['settings']),
            //   onTap: () {},
            // ),
            // Divider(
            //   thickness: getWidth(0.5),
            //   color: ColorUsed.DarkGreen,
            // ),
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
      
                if (shared!.getBool('isRegister') == true) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return CustomDialogAddService();
                      });
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
            ListTile(
              leading: Icon(Icons.language),
              title: Text(
                Translation[Language.chanage_lang],
                style: TextStyle(
                  fontSize: setFontSize(12),
                  fontWeight: FontWeight.w500,
                  color: ColorUsed.DarkGreen,
                ),
              ),
              onTap: () async {
                final read = context.read<LanguageController>();
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(S.of(context).chanage_lang),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (shared!.getString('lang') == 'en') {
                            Navigator.of(context).pop();
                            return;
                          }
                          read.changeLanguage('en');
                          Navigator.of(context).pop();
                        },
                        child: Text('English'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (shared!.getString('lang') == 'ar') {
                            Navigator.of(context).pop();
                            return;
                          }
                          read.changeLanguage('ar');
                          Navigator.of(context).pop();
                        },
                        child: Text('العربية'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(
              thickness: getWidth(0.5),
              color: ColorUsed.DarkGreen,
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text(
                Translation[Language.team_policy],
                style: TextStyle(
                  fontSize: setFontSize(10),
                  fontWeight: FontWeight.w400,
                  color: ColorUsed.DarkGreen,
                ),
              ),
              onTap: () {
                read.launchInBrowser(Uri.parse(Constant.PrivacyPolicy));
              },
            ),
            Divider(
              thickness: getWidth(0.1),
              color: ColorUsed.DarkGreen,
            ),
            Center(
              child: Text(
                Translation[Language.version] +
                    ':- (${packageInfo!.version}) ' +
                    packageInfo!.buildNumber,
                style: TextStyle(
                  fontSize: setFontSize(10),
                  fontWeight: FontWeight.w400,
                  color: ColorUsed.DarkGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
