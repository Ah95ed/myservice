import 'dart:developer';
import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';

import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/HaveAccount.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/TextFieldCustom.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const Route = 'login screen';
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: getheight(100),
              color: ColorUsed.PrimaryBackground,
              child: Column(
                children: [
                  Login_Image(
                    height: getheight(30),
                  ),
                  SizedBox(
                    height: getheight(4),
                  ),

                  //! enter phone
                  TextFieldCustom(
                    text: phone,
                    input: TextInputType.text,
                    icons: Icons.mobile_friendly,
                    hint: S.of(context).number_phone,
                  ),
                  SizedBox(
                    height: getheight(2),
                  ),

                  // //! password

                  TextFieldCustom(
                    text: password,
                    input: TextInputType.visiblePassword,
                    icons: Icons.key,
                    hint: S().enter_password,
                  ),
                  //! forget password
                  SizedBox(height: getheight(2)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(5)),
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
                    height: getheight(2),
                  ),
                  value.isLoading
                      ? CircularProgressIndicator()
                      : CustomMaterialButton(
                          title: S.of(context).login,
                          onPressed: () async {
                            value.startLoading();
                            if (phone.text.isEmpty || password.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.current.fields),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                            await value.login(
                              context,
                              phone.text,
                              password.text,
                            );
                            if (await value.isLoading) {
                                context.read<Providers>().managerScreenSplash(
                                    MainScreen.ROUTE,
                                    context,
                                    false,
                                  );
                              Logger.logger(
                                  'message login 2 -> ${value.isLoading}');
                              return;
                            
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تأكد من الرقم والباسورد'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              Logger.logger(
                                  'message login 1 -> ${value.isLoading}');

                              return;
                            }
                          },
                        ),

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
      },
    );
  }
}
