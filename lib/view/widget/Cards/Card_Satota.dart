import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';

import '../../ThemeApp/ColorUsed.dart';
import '../staticWidget/Multi_text.dart';

class CardSatota extends StatelessWidget {
  const CardSatota({
    super.key,
    required this.name,
    required this.location,
    required this.onPressed,
    this.onEdit,
    this.onDelete,
  });

  final String name, location;
  final VoidCallback onPressed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiText(name, S.of(context).name),
                SizedBox(height: getheight(1)),
                MultiText(location, S.of(context).title_service),
              ],
            ),
          ),
          Expanded(
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
