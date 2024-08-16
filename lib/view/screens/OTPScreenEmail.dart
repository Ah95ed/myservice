import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/ColorUsed.dart';

class OtpScreenEmail extends StatelessWidget {
  static const Route = "/OtpScreen";
  TextEditingController otpNumber = TextEditingController();
  OtpScreenEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signup = context.read<SignupProvider>();
    final providers = context.read<Providers>();
    return Scaffold(
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
              height: getheight(10),
              width: getWidth(70),
              child: AspectRatio(
                aspectRatio: 0.5,
                child: TextField(
                  controller: otpNumber,
                  autofocus: true,
                  showCursor: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: setFontSize(15),
                    fontWeight: FontWeight.bold,
                    color: ColorUsed.second,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorUsed.DarkGreen,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorUsed.DarkGreen,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
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
                if (EmailOTP.verifyOTP(otp: otpNumber.text)) {
                  await signup.saveData(
                    context,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translation[Language.otp_error],),
                    ),
                  );
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
