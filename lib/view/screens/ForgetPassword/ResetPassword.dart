import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const Route = '/ResetPassword';

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String? ?? '';

    return Scaffold(
      backgroundColor: ColorUsed.PrimaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getheight(8)),
            Text(
              Translation[Language.change_password],
              style: TextStyle(
                fontSize: setFontSize(16),
                fontWeight: FontWeight.bold,
                color: ColorUsed.second,
              ),
            ),
            SizedBox(height: getheight(4)),
            component1(
              _password,
              Icons.lock_outline,
              Translation[Language.enter_password],
              true,
              false,
            ),
            SizedBox(height: getheight(2)),
            component1(
              _confirm,
              Icons.lock_outline,
              Translation[Language.confirm],
              true,
              false,
            ),
            SizedBox(height: getheight(4)),
            CustomMaterialButton(
              title: Translation[Language.confirm],
              onPressed: () async {
                if (_password.text.isEmpty || _confirm.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Translation[Language.fields])),
                  );
                  return;
                }
                if (_password.text != _confirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translation[Language.error_password]),
                    ),
                  );
                  return;
                }
                showCirculerProgress(context);
                try {
                  await CloudflareApi.instance.resetPassword(
                    email: email,
                    newPassword: _password.text,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Translation[Language.done])),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
