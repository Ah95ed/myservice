import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
              onPressed: () async {},
            ),
          ),
        ],
      ),
    );
  }
}
