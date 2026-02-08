import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  static const Route = '/ForgetPassword';
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgetPasswordProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: ColorUsed.PrimaryBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Login_Image(height: getheight(28.0)),
              SizedBox(height: getheight(4)),
              component1(
                _emailController,
                Icons.email,
                Translation[Language.enter_email],
                false,
                true,
              ),
              SizedBox(height: getheight(4)),
              CustomMaterialButton(
                title: Translation[Language.send],
                onPressed: () async {
                  showCirculerProgress(context);
                  await value.sendCode(_emailController.text, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
