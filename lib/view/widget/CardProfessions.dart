import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'Multi_text.dart';

// ignore: must_be_immutable
class CardProfessions extends StatelessWidget {
  // const Professions({super.key});
  String name, nameProfession;
  VoidCallback onPressed;
  CardProfessions({
    super.key,
    required this.name,
    required this.nameProfession,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                MultiText(name, S.of(context).name),
                SizedBox(
                  height: 1.h,
                ),
                MultiText(nameProfession, S.of(context).profession),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
                icon: Icon(
                  Icons.call,
                  color: ColorUsed.primary,
                  size: 5.h,
                ),
                onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
