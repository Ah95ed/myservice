import 'package:Al_Zab_township_guide/view/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Models/provider/Provider.dart';
import '../widget/constant/Constant.dart';

class OtpScreen extends StatelessWidget {
  static const Route = "/OtpScreen";
  TextEditingController otpNumber = TextEditingController();
  OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = context.watch<Providers>();
    return Scaffold(
      body: Column(
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
          Expanded(
            child: SizedBox(
              height: 60,
              width: 50.w,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: TextField(
                  controller: otpNumber,
                  autofocus: true,
                  // onChanged: (value) {
                  //   // if (value.length == 4){
                  //   if (p.myauth.verifyOTP(confir)== true) {
                  //     context.read<Providers>().managerScreen(MainScreen.ROUTE, context);
                  //   }
                  //   // }
                  // },
                  showCursor: true,
                  readOnly: false,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
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
          ),
          ElevatedButton(
            onPressed: () {
              if (p.myauth.verifyOTP(otp: otpNumber.text)) {
                p.managerScreen(MainScreen.ROUTE, context);
              }
            },
            child: const Text('Confirme'),
          )
        ],
      ),
    );
  }
}
