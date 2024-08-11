import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/HaveAccount.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/TextFieldCustom.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../LoginScreen/login_screen.dart';

class SignupScreen extends StatelessWidget {
  static const Route = "/SignupScreen";
  SignupScreen({super.key});

  

  bool isSignup = false;

    TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: SingleChildScrollView(
            child: Container(
              height: getheight(100),
              width: getWidth(100),
              color: ColorUsed.PrimaryBackground,
              child: Form(
                
                child: Column(
                  children: [
                    Login_Image(
                      height: getheight(30),
                    ),
                    SizedBox(
                      height: getheight(4),
                    ),

                    // TextFormField(
                    //   controller: name,
                    //   decoration: InputDecoration(
                    //     labelText: S.of(context).name,
                    //     prefixIcon: Icon(Icons.person),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(
                    //         30

                    //     ),
                    //     ),
                    //   ),

                    // ),
                    TextFieldCustom(
                      text: name,
                      input: TextInputType.text,
                      icons: Icons.person,
                      hint: S.of(context).name,
                    ),
                    SizedBox(
                      height: getheight(2),
                    ),
                    // enter email
                    TextFieldCustom(
                      text: email,
                      input: TextInputType.emailAddress,
                      icons: Icons.email,
                      hint: S.of(context).enter_email,
                    ),
                    SizedBox(
                      height: getheight(2),
                    ),
                    // number phone
                    TextFieldCustom(
                      text: phone,
                      input: TextInputType.text,
                      icons: Icons.phone,
                      hint: S.of(context).number_phone,
                    ),
                    SizedBox(
                      height: getheight(2),
                    ),
                 
                    // enter password
                    TextFieldCustom(
                      text: password,
                      input: TextInputType.visiblePassword,
                      icons: Icons.key,
                      hint: S.of(context).enter_password,
                    ),
                    SizedBox(
                      height: getheight(2),
                    ),
                    provider.isSignup
                        ? CircularProgressIndicator()
                        : CustomMaterialButton(
                            title: S.of(context).register_now,
                            onPressed: () async {
                              provider.startLoading();
                              if (name.text.isEmpty ||
                                  email.text.isEmpty ||
                                  phone.text.isEmpty ||
                                  password.text.isEmpty) {
                                provider.stopLoading();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S.current.fields),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                
                                return;
                              }
                              if (!email.text.contains('@')) {
                                provider.stopLoading();
                                return;
                              }
                
                              await provider.sendCode(
                                SignupModel(
                                  name: name.text,
                                  email: email.text,
                                  phone: phone.text,
                                  password: password.text,
                                ),
                                context,
                              );
                
                              if (await provider.isSignup) {
                                context.read<Providers>().managerScreen(
                                      OtpScreen.Route,
                                      context,
                                    );
                                provider.stopLoading();
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.current.fields),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }),
                    SizedBox(
                      height: getheight(1),
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
          ),
        );
      },
    );
  }
}
