import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ThemeApp/ColorUsed.dart';
import '../staticWidget/Multi_text.dart';

// ignore: must_be_immutable
class CardCars extends StatelessWidget {
  late String name, type, time, number, from;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  CardCars({
    required this.name,
    required this.type,
    required this.time,
    required this.number,
    required this.from,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: getheight(0.5)),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiText(name, S.of(context).name),
                  MultiText(type, S.of(context).type),
                  MultiText(time, S.of(context).time),
                  MultiText(from, S.of(context).from),
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
                      size: getheight(3.5),
                      color: ColorUsed.second,
                    ),
                    onPressed: () async {
                      context.read<Providers>().callNumber(number);
                    },
                  ),
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: getheight(3),
                        color: ColorUsed.primary,
                      ),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: getheight(3),
                        color: Colors.red.shade700,
                      ),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
