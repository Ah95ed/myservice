import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/Multi_text.dart';
import 'package:Al_Zab_township_guide/Models/constant/Constant.dart';

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
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(1),
          vertical: getheight(0.5),
        ),
        child: Container(
          
          // height: getheight(20),
          decoration: BoxDecoration(
            
            border: Border.all(
              width: getWidth(0.2),
              color: ColorUsed.DarkGreen,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    MultiText(name, S.of(context).name),
                    SizedBox(
                      height: getheight(0.5),
                    ),
                    MultiText(type, S.of(context).type),
                    SizedBox(
                      height: getheight(0.5),
                    ),
                    MultiText(title, S.of(context).title_service),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
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
        ),
      ),
    );
  }
}
