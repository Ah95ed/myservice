import 'dart:developer';

import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/configSize/SizeConfig.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/HaveAccount.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/LoginBody.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMatireal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const Route = 'login screen';
   LoginScreen({super.key});
  TextEditingController? _email = TextEditingController();
  TextEditingController? _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          color: ColorUsed.PrimaryBackground,
          child: Column(
            children: [
              Login_Image(),
              SizedBox(height: SizeConfig.screenHeight * 0.04,),
              // enter email
              LoginBody(
                text: _email,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email,
                hintText: S.of(context).enter_email,
              ),
              LoginBody(
                text: _password,
                keyboardType: TextInputType.visiblePassword,
                icon: Icons.key,
                hintText: S().enter_password,
              ),
              // enter password
          
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    S.of(context).forget_password,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorUsed.DarkGreen,
          
                    ),
                  ),
                  onTap: ()  {
                    log('forget Password');
                  },
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04,),
              CustomMaterialButton(
                
                title: S.of(context).login,
                onPressed: () {
                  log('message ${_email!.text}');
                  log('message ${_password!.text}');
                },
              ),
              HaveAccount(),
            ],
          ),
        ),
      ),
    );
  }
}
