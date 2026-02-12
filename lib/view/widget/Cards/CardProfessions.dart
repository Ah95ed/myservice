import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:flutter/material.dart';

import '../staticWidget/Multi_text.dart';

// ignore: must_be_immutable
class CardProfessions extends StatelessWidget {
  // const Professions({super.key});
  String name, nameProfession;
  VoidCallback onPressed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  CardProfessions({
    super.key,
    required this.name,
    required this.nameProfession,
    required this.onPressed,
    this.onEdit,
    this.onDelete,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiText(name, S.of(context).name),
                SizedBox(height: getheight(2)),
                MultiText(nameProfession, S.of(context).profession),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: ColorUsed.primary,
                    size: getheight(3.5),
                  ),
                  onPressed: onPressed,
                ),
                if (onEdit != null)
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: ColorUsed.second,
                      size: getheight(3),
                    ),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade700,
                      size: getheight(3),
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
