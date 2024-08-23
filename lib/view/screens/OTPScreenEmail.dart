import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/ColorUsed.dart';

class OtpScreenEmail extends StatefulWidget {
  static const Route = "/OtpScreen";

  OtpScreenEmail({Key? key}) : super(key: key);

  @override
  State<OtpScreenEmail> createState() => _OtpScreenEmailState();
}

class _OtpScreenEmailState extends State<OtpScreenEmail> {
 late TextEditingController otpNumber  = TextEditingController();


@override
  void initState() {
// otpNumber  = TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final signup = context.read<SignupProvider>();
    final providers = context.read<Providers>();
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: getheight(30),
              decoration: const BoxDecoration(
                // color: Color(0xFF501063),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
                color: ColorUsed.primary, // Color(0xFF501063),
                gradient: LinearGradient(
                  colors: [
                    ColorUsed.primary, ColorUsed.second,
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
                      margin: EdgeInsets.symmetric(
                        vertical: getheight(4),
                      ),
                      height: getheight(14),
                      child: Image.asset(
                        'assets/logo/asd.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getheight(3),
            ),
            Text(
              Translation[Language.enter_otp_email],
              style: TextStyle(
                fontSize: setFontSize(16),
                fontWeight: FontWeight.bold,
                color: ColorUsed.second,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: getheight(3),
            ),
            SizedBox(
              height: getheight(8),
              width: getWidth(80),
              child: AspectRatio(
                aspectRatio: 0.5,
                child: TextFieldCustomEmailOTP(
                  otpNumber,
                  Icons.key,
                  Translation[Language.enter_otp_email],
                  false,
                  false,
                ),
              ),
            ),
            SizedBox(
              height: getheight(3),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: ColorUsed.primary,
                side: const BorderSide(
                  color: ColorUsed.DarkGreen,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                showCirculerProgress(context);
                if (EmailOTP.verifyOTP(otp: otpNumber.text)) {
                  await signup.saveData(
                    context,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Translation[Language.otp_error],
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(
                Translation[Language.confirm_otp],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: setFontSize(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldCustomEmailOTP extends StatelessWidget {
  TextFieldCustomEmailOTP(
    this.controller,
    this.icon,
    this.hintText,
    this.isPassword,
    this.isEmail,
  );
  TextEditingController? controller;
  IconData? icon;
  String? hintText;
  bool? isPassword;
  bool? isEmail;

  @override
  Widget build(BuildContext context) {
    // double _width = MediaQuery.of(context).size.width;
    return Container(
      height: getheight(10),
      width: getWidth(90),
      padding: EdgeInsets.symmetric(horizontal: getWidth(2)),
      decoration: BoxDecoration(
        color: ColorUsed.second.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        
        controller: controller!,
        style: TextStyle(
          color: Colors.white,
          fontSize: setFontSize(15),
        ),
        obscureText: isPassword!,
        keyboardType: isEmail! ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          // icon: Icon(
          //   icon,
          //   color: Colors.white.withOpacity(.7),
          // ),
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

          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: setFontSize(13),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
