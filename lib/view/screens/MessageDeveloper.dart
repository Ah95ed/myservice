import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/LoginBody.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MessageDeveloper extends StatelessWidget {
  const MessageDeveloper({super.key});
  static const String Route = 'MessageDeveloper';

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
                height: getheight(20),
              ),
              SizedBox(
                height: 1.h,
              ),
              TextFieldCustom(
                // text: name,
                input: TextInputType.text,
                icons: Icons.person,
                hint: S.of(context).name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
