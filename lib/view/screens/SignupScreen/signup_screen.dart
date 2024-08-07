import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/HaveAccount.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/LoginBody.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../LoginScreen/login_screen.dart';

class SignupScreen extends StatelessWidget {
  static const Route = "/SignupScreen";
  SignupScreen({super.key});

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController password = TextEditingController();

  bool isSignup = false;

  @override
  Widget build(BuildContext context) {
    // final providerSignup = context.read<SignupProvider>();
  
    return Consumer<SignupProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: SizerUtil.height,
            width: SizerUtil.width,
            color: ColorUsed.PrimaryBackground,
            child: provider.isSignup
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Login_Image(
                        height: 30.h,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFieldCustom(
                        text: name,
                        input: TextInputType.text,
                        icons: Icons.person,
                        hint:S.of(context).name,
                      ),
                      // enter email
                      TextFieldCustom(
                        text: email,
                        input: TextInputType.emailAddress,
                        icons: Icons.email,
                        hint: S.of(context).enter_email,
                      ),

                      // number phone
                      TextFieldCustom(
                        text: phone,
                        input: TextInputType.phone,
                        icons: Icons.phone,
                        hint: S.of(context).number_phone,
                      ),

                      // enter password
                      TextFieldCustom(
                        text: password,
                        input: TextInputType.visiblePassword,
                        icons: Icons.key,
                        hint: S.of(context).enter_password,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      CustomMaterialButton(
                          title: S.of(context).login,
                          onPressed: () async {
                          
                            provider.startLoading();
                            await provider.sendCode(
                              SignupModel(
                                name: name.text,
                                email: email.text,
                                phone: phone.text,
                                password: password.text,
                              ),
                              context,
                            );
                            await Future.delayed(Duration(seconds: 3));
                            provider.stopLoading();
                          }),
                      SizedBox(
                        height: 1.h,
                      ),
                      HaveAccount(
                        s1: S.of(context).already_member,
                        s2: S.of(context).login,
                        route: LoginScreen.Route,
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
