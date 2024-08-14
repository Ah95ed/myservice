import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/constant/Constant.dart';

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
        scrollDirection: Axis.vertical,
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
                      margin: const EdgeInsets.only(top: 50),
                      height: 80,
                      child: Image.asset(
                        path,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                        top: 20,
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                     Text(
                      Translation[''],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter your OTP code Email",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorUsed.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height:getheight(5),
            ),
            SizedBox(
              height: 60,
              width: getWidth(60),
              child: AspectRatio(
                aspectRatio: 0.5,
                child: TextField(
                  controller: otpNumber,
                  autofocus: false,
                  showCursor: false,
                  readOnly: false,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorUsed.primary,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: ColorUsed.primary,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: ColorUsed.primary,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: ColorUsed.primary,
                side: const BorderSide(
                  color: ColorUsed.second,
                ),
              ),
              onPressed: () async {
                if (EmailOTP.verifyOTP(otp: otpNumber.text)) {
                  await signup.saveData(
                    context,
                  );
                }
              },
              child:Text(
                S.current.confirm,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
