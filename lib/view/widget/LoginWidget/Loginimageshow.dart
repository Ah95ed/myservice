import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:flutter/material.dart';

class Login_Image extends StatelessWidget {
  const Login_Image({this.height, super.key});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            blurRadius: 4,
            color: ColorUsed.primary,
          ),
        ],
        gradient: LinearGradient(
          colors: [ColorUsed.primary, ColorUsed.second],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          height: getheight(12),
          child: Image.asset("assets/logo/asd.png"),
        ),
      ),
    );
  }
}

class LogoService extends StatelessWidget {
  const LogoService({this.height, this.title, super.key});

  final double? height;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: getWidth(100),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            blurRadius: 4,
            color: ColorUsed.primary,
          ),
        ],
        gradient: LinearGradient(
          colors: [ColorUsed.primary, ColorUsed.second],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: getheight(6)),
          Container(
            height: getheight(12),
            child: Image.asset("assets/logo/asd.png"),
          ),
          SizedBox(height: getheight(0.5)),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: setFontSize(14),
              fontWeight: FontWeight.bold,
              color: AppTheme.notWhite,
            ),
          ),
        ],
      ),
    );
  }
}
