import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/TextFieldCustom.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MessageDeveloper extends StatelessWidget {
  MessageDeveloper({super.key});
  static const String Route = 'MessageDeveloper';
  final TextEditingController name = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController description = TextEditingController();

  //! Here need design for Message Developer
  //! Mirna
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: getheight(100),
          width: getWidth(100),
          color: ColorUsed.PrimaryBackground,
          child: Column(
            children: [
              Login_Image(
                height: getheight(22),
              ),
              Spacer(),
              Text(
                S.current.send_developer,
                style: TextStyle(
                  fontSize: setFontSize(18),
                  color: ColorUsed.second,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: ColorUsed.DarkGreen,
                      offset: Offset(1, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
              Spacer(),
              TextFieldCustom(
                text: name,
                input: TextInputType.text,
                icons: Icons.person,
                hint: S.of(context).name,
              ),
              Spacer(),
              TextFieldCustom(
                text: name,
                input: TextInputType.phone,
                icons: Icons.phone,
                hint: S.of(context).number_phone,
              ),
              Spacer(),
              TextFieldCustom(
                text: name,
                input: TextInputType.text,
                icons: Icons.design_services,
                hint: S.of(context).service_type,
              ),
              Spacer(),
              TextFieldCustom(
                text: description,
                input: TextInputType.multiline,
                icons: Icons.description,
                hint: S.of(context).desctiption_message,
              ),
              Spacer(),
              CustomMaterialButton(
                title: S.current.send,
                onPressed: () {},
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(2.5)),
                child: Text(
                  textAlign: TextAlign.center,
                  S.current.if_you_need_send_me,
                  style: TextStyle(
                    fontSize: setFontSize(12),
                    color: ColorUsed.primary,
                    fontWeight: FontWeight.normal,
                    shadows: [
                      Shadow(
                        color: ColorUsed.DarkGreen,
                        offset: Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              DeveloperSocial(),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperSocial extends StatelessWidget {
  const DeveloperSocial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Container(
      width: getWidth(100),
      height: getheight(15),
      decoration: const BoxDecoration(
        color: ColorUsed.PrimaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            blurRadius: 4,
            color: ColorUsed.PrimaryBackground,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            ColorUsed.primary,
            ColorUsed.second,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          ImagesSocial(
            'assets/telegram.png',
            () {
              read.launchInBrowser(Uri.parse('https://t.me/Ah9_5D'));
            },
          ),
          Spacer(),
          ImagesSocial(
            'assets/messenger.png',
            () {
              read.launchInBrowser(Uri.parse('https://m.me/AH95ED'));
              // "https://m.me/AH95ED"
            },
          ),
          Spacer(),
          ImagesSocial(
            'assets/instagram.png',
            () {
              read.launchInBrowser(
                  Uri.parse('http://instagram.com/_u/ah_0.sh'));
            },
          ),
          Spacer(),
          ImagesSocial(
            'assets/whatsapp.png',
            () {
              read.launchInBrowser(
                Uri.parse('https://api.whatsapp.com/send?phone=+9647824854526'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImagesSocial extends StatelessWidget {
  ImagesSocial(this.path, this.onPressed, {super.key});

  String? path;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(4)),
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          path!,
          width: getWidth(10),
          height: getheight(10),
        ),
      ),
    );
  }
}
