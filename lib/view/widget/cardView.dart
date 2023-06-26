import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/Models/colorsProject.dart';
import 'package:tester_app/controller/provider/Provider.dart';

class CardViewList extends StatelessWidget {
  String? name, presence, time, number;

  CardViewList({super.key, this.name, this.presence, this.time, this.number});

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.6.w,
              color: const Color(0xFF5808FB),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(presence!,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black)),
                    Text(
                      time!,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.call,
                  size: 30.0,
                  color: ColorsProject.colorAppBar,
                ),
                onPressed: () async {
                  // _callNumber(number);
                  // _makePhoneCall(number);
                  value.callNumber(number!);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
