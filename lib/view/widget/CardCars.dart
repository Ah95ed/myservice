import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/colorsProject.dart';
import '../../controller/provider/Provider.dart';

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
    return Consumer<Providers>(builder: (context, value, child) {
      return Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
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
                  Text(type,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                  Text(
                    time,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Text(
                    from,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
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
              },
            ),
          ],
        ),
      );
    });
  }

  // _callNumber(String num) async {
  //   // const numb = '+9647824854526'; //set the number here
  //   bool? res = await FlutterPhoneDirectCaller.callNumber(num);
  // }
}
