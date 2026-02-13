import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/Multi_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CardDonors extends StatelessWidget {
  // const CardViewList({super.key});

  String name, type, title, number;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  CardDonors({
    super.key,
    required this.name,
    required this.type,
    required this.title,
    required this.number,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(1), // قلل البادينغ الجانبي
        vertical: getheight(0.5), // قلل البادينغ العلوي والسفلي
      ),
      child: Container(
        height: getheight(21), // زِد ارتفاع الكارد قليلاً
        decoration: BoxDecoration(
          border: Border.all(width: getWidth(0.2), color: ColorUsed.DarkGreen),
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: getheight(0.2)), // قلل المسافة العلوية
                  MultiText(name, S.of(context).name),
                  SizedBox(height: getheight(0.1)), // قلل المسافة بين النصوص
                  MultiText(type, S.of(context).type),
                  SizedBox(height: getheight(0.1)),
                  MultiText(title, S.of(context).title_service),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      size: getheight(2.7), // قلل حجم الأيقونة
                      color: ColorUsed.primary,
                    ),
                    padding: EdgeInsets.zero, // أزل البادينغ الافتراضي
                    constraints: BoxConstraints(),
                    onPressed: () async {
                      context.read<Providers>().callNumber(number);
                    },
                  ),
                  if (onEdit != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: getheight(0.1),
                      ), // قلل المسافة بين الأزرار
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: getheight(2.3), // قلل حجم الأيقونة
                          color: ColorUsed.second,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: onEdit,
                      ),
                    ),
                  if (onDelete != null)
                    Padding(
                      padding: EdgeInsets.only(top: getheight(0.1)),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: getheight(2.3),
                          color: Colors.red.shade700,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: onDelete,
                      ),
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
