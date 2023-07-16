// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../generated/l10n.dart';
import 'Multi_text.dart';

class CardSatota extends StatelessWidget {
  // const Professions({super.key});
  late String name, location;
  VoidCallback onPressed;
  CardSatota(
    {super.key, required this.name,required this.location,
    required this.onPressed
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
              children: [
                MultiText(name, S.of(context).name),
                SizedBox(
                  height: 1.h,
                ),
                MultiText(
                  location,
                  S.of(context).title_service,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.black,
                  size: 5.h,
                ),
                onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
