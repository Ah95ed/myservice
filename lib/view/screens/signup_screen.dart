import 'package:Al_Zab_township_guide/Models/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const Route = "login_screen";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final p = context.read<Providers>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                  ),
                  gradient: LinearGradient(colors: [
                    ColorUsed.primary, ColorUsed.second,
                    // (Color(0xFF501063)),
                    // (Color.fromRGBO(89, 29, 107, 1)),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      height: 100,
                      child: Image.asset("assets/asd.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        S.of(context).register_now,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Full Name
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
              ),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE))
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: name,
                cursorColor: ColorUsed.primary, // Color(0xFF501063),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.person,
                    color: ColorUsed.primary, // Color(0xFF501063),
                  ),
                  hintText: S.of(context).name,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            // enter email
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE))
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                cursorColor: ColorUsed.primary, //Color(0xFF501063),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.email,
                    color: ColorUsed.primary, //Color(0xFF501063),
                  ),
                  hintText: S.of(context).enter_email,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            // number phone
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xffEEEEEE),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                cursorColor: ColorUsed.primary,
                // const Color(0xFF501063),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.phone,
                    color: ColorUsed.primary, //Color(0xFF501063),
                  ),
                  hintText: S.of(context).number_phone,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            // enter password
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Color(0xffEEEEEE))
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: ColorUsed.primary, //Color(0xFF501063),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.vpn_key,
                    color: ColorUsed.primary, //Color(0xFF501063),
                  ),
                  hintText: S.of(context).enter_password,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (name.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('حقل الاسم فارغ')));
                  return;
                }
                if (email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('حقل الايميل فارغ')));
                  return;
                }
                if (phone.text.isEmpty && phone.text.length < 11) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تأكد من الر قم")));
                  return;
                }
                if (password.text.isEmpty && password.text.length > 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('حقل الباسورد فارغ')));
                  return;
                }
                await context.read<Providers>().registerWithEmailOTP(
                      email.text,
                      password.text,
                      name.text,
                      phone.text,
                      context,
                    );
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 40,
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    ColorUsed.primary,
                    ColorUsed.second,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE))
                  ],
                ),
                child: Text(
                  S.of(context).register_now,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            // Register
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).already_member,
                  ),
                  SizedBox(
                    width: 0.5.w,
                  ),
                  GestureDetector(
                    onTap: () => {
                      p.managerScreenSplash(LoginScreen.Route, context, false)
                    },
                    child: Text(
                      S.of(context).login,
                      style: const TextStyle(
                        color: ColorUsed.primary, // Color(0xFF501063),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
