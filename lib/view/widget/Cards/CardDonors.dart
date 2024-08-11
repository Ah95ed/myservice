import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/Multi_text.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';

// ignore: must_be_immutable
class CardDonors extends StatelessWidget {
  // const CardViewList({super.key});

  String name, type, title, number;

  CardDonors(
      {super.key,
      required this.name,
      required this.type,
      required this.title,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getWidth(2),
                vertical: getheight(2),
              ),
              child: Column(
                children: [
                  MultiText(name, S.of(context).name),
                  MultiText(type, S.of(context).type),
                  MultiText(title, S.of(context).title_service),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              icon: Icon(
                Icons.call,
                size: getheight(4),
                color: ColorUsed.primary,
              ),
              onPressed: () async {
                context.read<Providers>().callNumber(number);
              },
            ),
          ),
        ],
      ),
    );
  }
}
