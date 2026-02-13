import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/screens/GradesScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/ProfileScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Customdrawer extends StatelessWidget {
  const Customdrawer({super.key});

  static const MethodChannel _shareChannel = MethodChannel('com.blood.share');

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
                          SizedBox(height: getheight(0.5)),
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
            SizedBox(height: getheight(0.2)),
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
            Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                Translation[Language.profile],
                style: TextStyle(
                  fontSize: setFontSize(12),
                  fontWeight: FontWeight.w500,
                  color: ColorUsed.DarkGreen,
                ),
              ),
              onTap: () {
                read.managerScreen(ProfileScreen.Route, context);
              },
            ),
            Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
            // ListTile(
            //   leading: Icon(Icons.delete, color: Colors.red.shade700),
            //   title: Text(
            //     Translation[Language.delete_account],
            //     style: TextStyle(
            //       fontSize: setFontSize(12),
            //       fontWeight: FontWeight.w500,
            //       color: Colors.red.shade700,
            //     ),
            //   ),
            //   onTap: () {
            //     Scaffold.of(context).closeDrawer();
            //     if (shared!.getBool('isRegister') != true) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(Translation[Language.register_first]),
            //         ),
            //       );
            //       return;
            //     }
            //     showDialog(
            //       context: context,
            //       builder: (dialogContext) {
            //         return AlertDialog(
            //           title: Text(Translation[Language.delete_account]),
            //           content: Text(
            //             Translation[Language.sure_to_delete_account],
            //           ),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.pop(dialogContext),
            //               child: Text(Translation[Language.no]),
            //             ),
            //             TextButton(
            //               onPressed: () async {
            //                 Navigator.pop(dialogContext);
            //                 showCirculerProgress(context);
            //                 final phone = shared!.getString('phoneUser') ?? '';
            //                 await context
            //                     .read<Updateprovider>()
            //                     .deleteDataFromRealtime(context, phone);
            //                 await SecureStorageService.clearAll();
            //               },
            //               child: Text(Translation[Language.yes]),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
            // Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
            ListTile(
              leading: Icon(Icons.share),
              title: Text(Translation[Language.share_app]),
              onTap: () async {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }

                const shareText =
                    'https://play.google.com/store/apps/details?id=com.Blood.types';
                const shareSubject = 'رابط التطبيق على كوكل بلي';

                final box = context.findRenderObject() as RenderBox?;
                final origin = box != null
                    ? box.localToGlobal(Offset.zero) & box.size
                    : null;

                try {
                  if (!kIsWeb &&
                      defaultTargetPlatform == TargetPlatform.android) {
                    await _shareChannel.invokeMethod('shareText', {
                      'text': shareText,
                      'subject': shareSubject,
                    });
                    return;
                  }

                  if (origin != null) {
                    await Share.share(
                      shareText,
                      subject: shareSubject,
                      sharePositionOrigin: origin,
                    );
                  } else {
                    await Share.share(shareText, subject: shareSubject);
                  }
                } on MissingPluginException {
                  if (origin != null) {
                    await Share.share(
                      shareText,
                      subject: shareSubject,
                      sharePositionOrigin: origin,
                    );
                  } else {
                    await Share.share(shareText, subject: shareSubject);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),

            // إظهار زر التعديل فقط للأدمن
            if (shared!.getString('emailUser') == 'amhmeed31@gmail.com' ||
                shared!.getString('phoneUser') == '07824854526')
              Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
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
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translation[Language.register_first]),
                    ),
                  );
                }
              },
            ),
            Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
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
            Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(
                Translation[Language.bookSchool],
                style: TextStyle(
                  fontSize: setFontSize(12),
                  fontWeight: FontWeight.bold,
                  color: ColorUsed.DarkGreen,
                ),
              ),
              onTap: () {
                managerScreen(GradesScreen.route, context);
              },
            ),
            Divider(thickness: getWidth(0.5), color: ColorUsed.DarkGreen),
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
            Divider(thickness: getWidth(0.1), color: ColorUsed.DarkGreen),
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

            // ... باقي عناصر القائمة هنا ...
          ],
        ),
      ),
    );
  }
}
