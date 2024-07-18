import 'dart:developer';

import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
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

  
  TextEditingController? _email;
  TextEditingController? _password;

  



  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Login_Image(),
            // enter email
            LoginBody(
              text: _email,
              keyboardType: TextInputType.emailAddress,
              icon: Icons.email,
            ),
            LoginBody(
              text: _password,
              keyboardType: TextInputType.visiblePassword,
              icon: Icons.key,
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
                    color: ColorUsed.primary

                  ),
                ),
                onTap: ()  {
                  log('forget Password');
                },
              ),
            ),
            SizedBox(height: 4.h,),
            CustomMaterialButton(
              title: S.of(context).login,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).don_t_have_account,
                  ),
                  SizedBox(
                    width: 0.5.w,
                  ),
                  GestureDetector(
                    onTap: () => {
                      read.managerScreenSplash(
                          SignupScreen.Route, context, false)
                    },
                    child: Text(
                      S.of(context).register_now,
                      style: const TextStyle(
                        color: ColorUsed.primary, // Color(0xFF501063),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
