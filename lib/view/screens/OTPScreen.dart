import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Models/provider/Provider.dart';
import '../widget/ButtonSelect.dart';
import '../widget/constant/Constant.dart';

class OtpScreen extends StatelessWidget {
  static const Route = "/OtpScreen";
  TextEditingController otpNumber = TextEditingController();
  OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<Providers>();
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
                        "assets/Ichrak.png",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                        top: 20,
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                    const Text(
                      'OTP Verifying',
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
              height: 5.h,
            ),
            SizedBox(
              height: 60,
              width: 60.w,
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
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 60.w,
              child: ButtonSelect(
                title: 'Confirm',
                onPressed: () async {
                  if (p.myauth.verifyOTP(otp: otpNumber.text)) {
                  await p.saveData(context);
                 
                  }
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
