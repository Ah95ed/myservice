import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../staticWidget/Multi_text.dart';
import '../constant/Constant.dart';

class CardSatota extends StatelessWidget {
  // const Professions({super.key});
  late String name, location;
  VoidCallback onPressed;
  CardSatota(
      {super.key,
      required this.name,
      required this.location,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                MultiText(name, S.of(context).name),
                SizedBox(
                  height: getheight(1),
                ),
                MultiText(
                  location,
                  S.of(context).title_service,
                ),
              ],
            ),
          ),
          Expanded(
          
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
