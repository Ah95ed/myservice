import 'package:Al_Zab_township_guide/Models/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const Route = 'login screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? _email;
  TextEditingController? _password;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.read<Providers>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
                color: ColorUsed.primary, // Color(0xFF501063),
                gradient: LinearGradient(
                  colors: [
                    ColorUsed.primary,
                    ColorUsed.second,
                    // (Color(0xFF501063)),
                    // (Color(0xFF591D6B)),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      height: 100,
                      child: Image.asset(
                        "assets/asd.png",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                        top: 20,
                      ),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        S.of(context).login,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // enter email
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 70,
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  50,
                ),
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
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                cursorColor: ColorUsed.primary, //Color(0xFF501063),
                decoration: InputDecoration(
                    icon: const Icon(
                      Icons.email,
                      color: ColorUsed.primary, //Color(0xFF501063),
                    ),
                    hintText: S.of(context).enter_email,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            // enter password
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xffEEEEEE),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _password,
                obscureText: true,
                cursorColor: ColorUsed.primary,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    icon: const Icon(
                      Icons.vpn_key,
                      color: ColorUsed.primary, //Color(0xFF501063),
                    ),
                    hintText: S.of(context).enter_password,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 22, right: 30),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Text(
                    S.of(context).forget_password,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => {},
                ),
              ),
            ),

            GestureDetector(
              onTap: () =>
                  {p.loginFirebase(_email!.text, _password!.text, context)},
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 60,
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    ColorUsed.primary,
                    ColorUsed.second,
                    // (Color(0xFF501063)),
                    // (Color(0xFF591D6B)),
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
                  S.of(context).login,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
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
p.managerScreenSplash(SignupScreen.Route, context, false)
                    },
                    child: Text(
                      S.of(context).register_now,
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
