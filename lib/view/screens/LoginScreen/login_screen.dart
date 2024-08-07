import 'dart:developer';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/HaveAccount.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/LoginBody.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const Route = 'login screen';
  late TextEditingController email = TextEditingController();
  late TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {


    final providerLogin = context.read<LoginProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizerUtil.height,
          color: ColorUsed.PrimaryBackground,
          child: Column(
            children: [
              Login_Image(height: 40.h,),
              SizedBox(
                height: 6.h,
              ),

              //! enter email
              TextFieldCustom(
                text: email,
                input: TextInputType.emailAddress,
                icons: Icons.email,
                hint: S.of(context).enter_email,
              ),

// //! password

              TextFieldCustom(
                text: password,
                input: TextInputType.visiblePassword,
                icons: Icons.key,
                hint: S().enter_password,
              ),
              //! forget password
              SizedBox(
                height: 2.h,
              ),
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
                  onTap: () {
                    log('forget Password');
                  },
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              CustomMaterialButton(
                title: S.of(context).login,
                onPressed: () {
                  providerLogin.loginFirebase(
                    email.text,
                    password.text,
                    context,
                  );
                  // log(message ${email.text});
                  // log(message ${password.text});
                },
              ),
              SizedBox(height: 1.h,),
              HaveAccount(
                s1: S.of(context).don_t_have_account,
                s2: S.of(context).register_now,
                route: SignupScreen.Route,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
