import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/controller/provider/DeveloperController/DeveloperController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MessageDeveloper extends StatefulWidget {
  MessageDeveloper({super.key});
  static const String Route = 'MessageDeveloper';

  @override
  State<MessageDeveloper> createState() => _MessageDeveloperState();
}

class _MessageDeveloperState extends State<MessageDeveloper>
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

    _animation =
        Tween<double>(
            begin: .7,
            end: 1,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    name.dispose();
    number.dispose();
    type.dispose();
    description.dispose();
    super.dispose();
  }

  final TextEditingController name = TextEditingController();

  final TextEditingController number = TextEditingController();

  final TextEditingController type = TextEditingController();

  final TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final read = context.read<DeveloperController>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: getheight(100),
          child: Column(
            children: [
              Login_Image(height: getheight(20)),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SizedBox(height: getheight(2)),
                    component1(
                      name,
                      Icons.person,
                      S.current.please_enter_name,
                      false,
                      false,
                    ),
                    SizedBox(height: getheight(2)),
                    component1(
                      number,
                      Icons.phone,
                      S.current.number_phone,
                      false,
                      false,
                    ),
                    SizedBox(height: getheight(2)),
                    component1(
                      type,
                      Icons.type_specimen,
                      S.current.type,
                      false,
                      false,
                    ),
                    SizedBox(height: getheight(2)),
                    component1(
                      description,
                      Icons.description,
                      S.current.description,
                      false,
                      false,
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
                        margin: EdgeInsets.only(bottom: getheight(5)),
                        height: getheight(100),
                        width: getWidth(100),
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
                            if (name.text.isEmpty ||
                                number.text.isEmpty ||
                                type.text.isEmpty ||
                                description.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.current.fields),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            read.sendDataToDeveloper({
                              'name': name.text,
                              'number': number.text,
                              "type": type.text,
                              'description': description.text,
                            }, number.text);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: getheight(5)),
                            height: getheight(14),
                            width: getWidth(30),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorUsed.DarkGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              S.current.send_request,
                              style: TextStyle(
                                color: AppTheme.nearlyWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: setFontSize(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(2)),
                child: Text(
                  S.current.if_you_need_send_me,
                  style: TextStyle(
                    color: ColorUsed.DarkGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: setFontSize(12),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: getheight(1)),
              Expanded(child: DeveloperSocial()),
            ],
          ),
        ),
      ),
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
        style: TextStyle(color: Colors.white, fontSize: setFontSize(16)),
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
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(.7)),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: setFontSize(15), color: Colors.white),
        ),
      ),
    );
  }
}

class DeveloperSocial extends StatelessWidget {
  const DeveloperSocial({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Container(
      width: getWidth(100),
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
          colors: [ColorUsed.primary, ColorUsed.second],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          ImagesSocial('assets/logo/telegram.png', () {
            read.launchInBrowser(Uri.parse('https://t.me/Ah9_5D'));
          }),
          Spacer(),
          ImagesSocial('assets/logo/messenger.png', () {
            read.launchInBrowser(Uri.parse('https://m.me/AH95ED'));
            // "https://m.me/AH95ED"
          }),
          Spacer(),
          ImagesSocial('assets/logo/instagram.png', () {
            read.launchInBrowser(Uri.parse('http://instagram.com/_u/ah_0.sh'));
          }),
          Spacer(),
          ImagesSocial('assets/logo/whatsapp.png', () {
            read.launchInBrowser(
              Uri.parse('https://api.whatsapp.com/send?phone=+9647824854526'),
            );
          }),
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
          // height: getheight(8),
        ),
      ),
    );
  }
}
