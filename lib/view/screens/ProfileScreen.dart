import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const Route = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    final updater = context.read<Updateprovider>();

    final name = shared?.getString('nameUser') ?? '';
    final email = shared?.getString('emailUser') ?? '';
    final phone = shared?.getString('phoneUser') ?? '';
    final isRegister = shared?.getBool('isRegister') == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('البروفايل'),
        backgroundColor: ColorUsed.primary,
        foregroundColor: AppTheme.notWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(6),
          vertical: getheight(3),
        ),
        child: Column(
          children: [
            _ProfileCard(
              name: name,
              email: email,
              phone: phone,
              isRegister: isRegister,
            ),
            SizedBox(height: getheight(3)),
            _ActionTile(
              icon: Icons.logout,
              color: ColorUsed.second,
              title: Translation[Language.logout],
              onTap: () {
                if (!isRegister) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translation[Language.register_first]),
                    ),
                  );
                  return;
                }
                shared?.remove('nameUser');
                shared?.remove('emailUser');
                shared?.remove('phoneUser');
                shared?.remove('isRegister');
                read.managerScreenSplash(LoginScreen.Route, context, false);
              },
            ),
            SizedBox(height: getheight(2)),
            _ActionTile(
              icon: Icons.person_add_alt_1,
              color: ColorUsed.primary,
              title: Translation[Language.register_now],
              onTap: () {
                read.managerScreen(SignupScreen.Route, context);
              },
            ),
            SizedBox(height: getheight(2)),
            _ActionTile(
              icon: Icons.delete_forever,
              color: Colors.red.shade700,
              title: Translation[Language.delete_account],
              onTap: () {
                if (!isRegister) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translation[Language.register_first]),
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(Translation[Language.delete_account]),
                      content: Text(
                        Translation[Language.sure_to_delete_account],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(Translation[Language.no]),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            if (phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    Translation[Language.please_enter_phone],
                                  ),
                                ),
                              );
                              return;
                            }

                            showCirculerProgress(context);
                            await updater.deleteDataFromRealtime(
                              context,
                              phone,
                            );
                          },
                          child: Text(Translation[Language.yes]),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final bool isRegister;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.isRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(4),
        vertical: getheight(3),
      ),
      decoration: BoxDecoration(
        color: ColorUsed.second.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorUsed.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: getWidth(12),
            backgroundColor: ColorUsed.primary,
            child: Icon(
              Icons.person,
              size: getWidth(12),
              color: AppTheme.notWhite,
            ),
          ),
          SizedBox(height: getheight(2)),
          _InfoRow(
            label: Translation[Language.name],
            value: name.isNotEmpty ? name : '--',
          ),
          SizedBox(height: getheight(1.5)),
          _InfoRow(
            label: Translation[Language.enter_email],
            value: email.isNotEmpty ? email : '--',
          ),
          SizedBox(height: getheight(1.5)),
          _InfoRow(
            label: Translation[Language.number_phone],
            value: phone.isNotEmpty ? phone : '--',
          ),
          if (!isRegister) ...[
            SizedBox(height: getheight(2)),
            Text(
              Translation[Language.register_first],
              style: TextStyle(
                color: ColorUsed.second,
                fontSize: setFontSize(12),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: color.withOpacity(0.1),
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: setFontSize(13),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorUsed.DarkGreen,
            fontSize: setFontSize(12),
            fontWeight: FontWeight.w600,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppTheme.nearlyBlack,
              fontSize: setFontSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
