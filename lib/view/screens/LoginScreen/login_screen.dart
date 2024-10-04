// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';

class LoginScreen extends StatefulWidget {
  static const Route = 'login screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: .7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )
      ..addListener(
        () {
          setState(() {});
        },
      )
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ColorUsed.PrimaryBackground,
          body: SingleChildScrollView(
            child: SizedBox(
              height: getheight(100),
              child: Column(
                children: [
                  // Expanded(child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Login_Image(
                      height: getheight(1),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: getheight(3),
                        ),
                        component1(
                          phone,
                          Icons.phone,
                          S.current.number_phone,
                          false,
                          true,
                        ),
                        SizedBox(
                          height: getheight(3),
                        ),
                        component1(
                          password,
                          Icons.lock_outline,
                          S.current.enter_password,
                          true,
                          false,
                        ),
                        SizedBox(
                          height: getheight(4),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: S.current.forget_password,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: setFontSize(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      HapticFeedback.lightImpact();
                                      //   Fluttertoast.showToast(
                                      //       msg:
                                      //           'Forgotten password! button pressed');
                                      // },
                                    }),
                            ),
                            SizedBox(width: getWidth(24)),
                            RichText(
                              text: TextSpan(
                                text: S.current.don_t_have_account,
                                style: TextStyle(
                                  color: ColorUsed.DarkGreen,
                                  fontSize: setFontSize(12),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.lightImpact();
                                    context.read<Providers>().managerScreen(
                                        SignupScreen.Route, context);
                                  },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: getheight(12),
                            ),
                            height: getheight(40),
                            width: getWidth(60),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  ColorUsed.PrimaryBackground,
                                  ColorUsed.second,
                                  ColorUsed.DarkGreen,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Transform.scale(
                            scale: _animation.value,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                HapticFeedback.lightImpact();

                                showCirculerProgress(context);
                                //! here to on click login
                                // provider.startLoading();
                                if (phone.text.isEmpty ||
                                    password.text.isEmpty) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(S.current.fields),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                await provider.login(
                                  context,
                                  phone.text,
                                  password.text,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: getheight(12),
                                ),
                                height: getheight(18),
                                width: getWidth(30),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorUsed.DarkGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  S.current.login,
                                  style: TextStyle(
                                      color: AppTheme.nearlyWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: setFontSize(12)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class component1 extends StatelessWidget {
  component1(
    this.controller,
    this.icon,
    this.hintText,
    this.isPassword,
    this.isEmail,
  );
  TextEditingController controller;
  IconData? icon;
  String? hintText;
  bool? isPassword;
  bool? isEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getheight(7),
      width: getWidth(90),
      padding: EdgeInsets.symmetric(horizontal: getWidth(2)),
      decoration: BoxDecoration(
        color: ColorUsed.second.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: setFontSize(16),
        ),
        obscureText: isPassword!,
        keyboardType: isEmail! ? TextInputType.emailAddress
         : TextInputType.text,
        decoration: InputDecoration(
         
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorUsed.primary,
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(.7),
          ),
          // border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: setFontSize(15),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
