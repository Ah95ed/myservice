import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Multi_text.dart';

import '../../Models/provider/Provider.dart';
import 'constant/Constant.dart';

// ignore: must_be_immutable
class CardViewList extends StatelessWidget {
  String? name, presence, specialization, number, title;

  CardViewList(
      {super.key,
      this.name,
      this.presence,
      this.specialization,
      this.number,
      this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.sp,
      shadowColor: Colors.tealAccent,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                MultiText(name!, S.of(context).name),
                MultiText(presence!, S.of(context).time),
                MultiText(specialization!, S.of(context).specialization),
                MultiText(title!, S.of(context).title_service),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: Icon(
                Icons.call,
                size: 4.h,
                color: ColorUsed.primary,
              ),
              onPressed: () {
                context.read<Providers>().callNumber(number!);
              },
            ),
          ),
        ],
      ).animate().addEffect(
            const MoveEffect(
              begin: Offset(25, 15),
              duration: Duration(milliseconds: 900),
              delay: Duration(milliseconds: 500),
              curve: Curves.linear,
            ),
          ),
    );
  }
}
