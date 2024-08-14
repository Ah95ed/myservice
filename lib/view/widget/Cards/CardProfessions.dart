import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/Models/constant/Constant.dart';
import 'package:flutter/material.dart';

import '../staticWidget/Multi_text.dart';

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
                  height: getheight(2),
                ),
                MultiText(
                  nameProfession,
                  S.of(context).profession,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
                icon: Icon(
                  Icons.call,
                  color: ColorUsed.primary,
                  size: getheight(4),
                ),
                onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
