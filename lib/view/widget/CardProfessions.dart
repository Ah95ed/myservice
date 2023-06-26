import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/colorsProject.dart';
import '../../controller/provider/Provider.dart';

// ignore: must_be_immutable
class CardProfessions extends StatelessWidget {
  // const Professions({super.key});
  String name, number, nameProfession;
  CardProfessions(
      {super.key,
      required this.name,
      required this.number,
      required this.nameProfession});

  @override
  Widget build(BuildContext context) {
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
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
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      nameProfession,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
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
                  value.callNumber(number);
                  // _makePhoneCall(number);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // _callNumber(String num) async {
  //   // const numb = '+9647824854526'; //set the number here
  //   bool? res = await FlutterPhoneDirectCaller.callNumber(num);
  // }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('not call ____');
    }
  }
}
