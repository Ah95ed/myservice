import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../LoginScreen/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';

class SignupScreen extends StatefulWidget {
  static const Route = "/SignupScreen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
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
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ColorUsed.PrimaryBackground,
          body: SingleChildScrollView(
            child: SizedBox(
              height: getheight(100),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Login_Image(
                      // height: getheight(0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: getheight(2),
                        ),
                          component1(
                          name,
                          Icons.person,
                          S.current.please_enter_name,
                          false,
                          false,
                        ),
                        SizedBox(
                          height: getheight(2),
                        ),
                         component1(
                          email,
                          Icons.email,
                          S.current.enter_email,
                          false,
                          false,
                        ),
                        SizedBox(
                          height: getheight(2),
                        ),
                        component1(
                          phone,
                          Icons.phone,
                          S.current.number_phone,
                          false,
                          true,
                        ),
                        SizedBox(
                          height: getheight(2),
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
                            
                            SizedBox(width: getWidth(30)),
                            RichText(
                              text: TextSpan(
                                text: S.current.already_member ,
                                style: TextStyle(
                                  color: ColorUsed.DarkGreen,
                                  fontSize: setFontSize(12),
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.lightImpact();
                                    context.read<Providers>().managerScreen(
                                        LoginScreen.Route, context);
                                  },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: getheight(5),
                              
                              
                            ),
                            // height: getheight(100),
                            // width: getWidth(100),
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
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('ادخل أيميل حقيقي'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
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
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: getheight(5),
                                ),
                                height: getheight(14),
                                width: getWidth(30),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorUsed.DarkGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  S.current.register_now,
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
    // double _width = MediaQuery.of(context).size.width;
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
        keyboardType: isEmail! ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          // icon: Icon(
          //   icon,
          //   color: Colors.white.withOpacity(.7),
          // ),
          // border: const OutlineInputBorder(),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: ColorUsed.primary,
          //   ),
          // ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(.7),
          ),
          border: InputBorder.none,
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


// class SignupScreen extends StatelessWidget {
//   static const Route = "/SignupScreen";
//   SignupScreen({super.key});

  

//   bool isSignup = false;

//     TextEditingController name = TextEditingController();

//   TextEditingController email = TextEditingController();

//   TextEditingController phone = TextEditingController();

//   TextEditingController password = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SignupProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           extendBodyBehindAppBar: true,
//           extendBody: true,
//           body: SingleChildScrollView(
//             child: Container(
//               height: getheight(100),
//               width: getWidth(100),
//               color: ColorUsed.PrimaryBackground,
//               child: Form(
                
//                 child: Column(
//                   children: [
//                     // Login_Image(
//                     //   height: getheight(30),
//                     // ),
//                     SizedBox(
//                       height: getheight(20),
//                     ),

//                     // TextFormField(
//                     //   controller: name,
//                     //   decoration: InputDecoration(
//                     //     labelText: S.of(context).name,
//                     //     prefixIcon: Icon(Icons.person),
//                     //     border: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(
//                     //         30

//                     //     ),
//                     //     ),
//                     //   ),

//                     // ),
//                     TextFieldCustom(
//                       text: name,
//                       input: TextInputType.text,
//                       icons: Icons.person,
//                       hint: S.of(context).name,
//                     ),
//                     SizedBox(
//                       height: getheight(2),
//                     ),
//                     // enter email
//                     TextFieldCustom(
//                       text: email,
//                       input: TextInputType.emailAddress,
//                       icons: Icons.email,
//                       hint: S.of(context).enter_email,
//                     ),
//                     SizedBox(
//                       height: getheight(2),
//                     ),
//                     // number phone
//                     TextFieldCustom(
//                       text: phone,
//                       input: TextInputType.text,
//                       icons: Icons.phone,
//                       hint: S.of(context).number_phone,
//                     ),
//                     SizedBox(
//                       height: getheight(2),
//                     ),
                 
//                     // enter password
//                     TextFieldCustom(
//                       text: password,
//                       input: TextInputType.visiblePassword,
//                       icons: Icons.key,
//                       hint: S.of(context).enter_password,
//                     ),
//                     SizedBox(
//                       height: getheight(2),
//                     ),
//                     provider.isSignup
//                         ? CircularProgressIndicator()
//                         : CustomMaterialButton(
//                             title: S.of(context).register_now,
//                             onPressed: () async {
//                               provider.startLoading();
//                               if (name.text.isEmpty ||
//                                   email.text.isEmpty ||
//                                   phone.text.isEmpty ||
//                                   password.text.isEmpty) {
//                                 provider.stopLoading();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(S.current.fields),
//                                     duration: Duration(seconds: 3),
//                                   ),
//                                 );
                
//                                 return;
//                               }
//                               if (!email.text.contains('@')) {
//                                 provider.stopLoading();
//                                 return;
//                               }
                
//                               await provider.sendCode(
//                                 SignupModel(
//                                   name: name.text,
//                                   email: email.text,
//                                   phone: phone.text,
//                                   password: password.text,
//                                 ),
//                                 context,
//                               );
                
//                               if (await provider.isSignup) {
//                                 context.read<Providers>().managerScreen(
//                                       OtpScreen.Route,
//                                       context,
//                                     );
//                                 provider.stopLoading();
//                                 return;
//                               }
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(S.current.fields),
//                                   duration: Duration(seconds: 3),
//                                 ),
//                               );
//                             }),
//                     SizedBox(
//                       height: getheight(1),
//                     ),
//                     HaveAccount(
//                       s1: S.of(context).already_member,
//                       s2: S.of(context).login,
//                       route: LoginScreen.Route,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
