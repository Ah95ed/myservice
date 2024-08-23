import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../staticWidget/Multi_text.dart';
import '../../ThemeApp/ColorUsed.dart';

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
   
    return Card(
      elevation: 5,
     
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 6,
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
               
                child: IconButton(
                  icon: Icon(
                    Icons.call,
                    size: getWidth(8),
                    color: ColorUsed.second,
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
