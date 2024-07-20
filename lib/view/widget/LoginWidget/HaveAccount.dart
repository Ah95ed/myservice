import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/screens/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final read = context.read<Providers>();
    return Container(
      margin:  EdgeInsets.only(top:0.1.h),
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).don_t_have_account,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorUsed.DarkGreen,
            ),
          ),
          SizedBox(
            width: 0.1.w,
          ),
          TextButton(
            autofocus: true,
            onPressed: () =>
                {read.managerScreenSplash(SignupScreen.Route, context, false)},
            child: Text(
              S.of(context).register_now,
              style: TextStyle(
                  color: ColorUsed.second,
                  fontWeight: FontWeight.bold // Color(0xFF501063),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
