import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../staticWidget/Multi_text.dart';
import '../constant/Constant.dart';

// ignore: must_be_immutable
class CardCars extends StatelessWidget {
  late String name, type, time, number, from;

  CardCars({
    required this.name,
    required this.type,
    required this.time,
    required this.number,
    required this.from,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var s = S;
    return Card(
      elevation: 8,
      shadowColor: Colors.teal,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                MultiText(name, S.of(context).name),
                MultiText(type, S.of(context).type),
                MultiText(time, S.of(context).time),
                MultiText(from, S.of(context).from),
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
