import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/Multi_text.dart';

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
      elevation: 8.sp,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(1.w),
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
                size: 4.h,
                color: Colors.black,
              ),
              onPressed: () async {
                context.read<Providers>().callNumber(number);
              },
            ),
          ),
        ],
      ),
    ).animate().addEffect(
              const MoveEffect(
                begin: Offset(0.0, 60),
                duration: Duration(milliseconds: 1000),
                delay: Duration(milliseconds: 500),
                curve: Curves.linear,
              ),
            );
  }
}
