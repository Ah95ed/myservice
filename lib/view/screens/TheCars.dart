import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tester_app/controller/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardCars.dart';

import '../../controller/Constant/CustomSearchDelegate.dart';

class TheCars extends StatelessWidget {
  static const ROUTE = 'TheCars';

  const TheCars({super.key});

  @override
  Widget build(BuildContext context) {
    final ss = Provider.of<Providers>(context, listen: false);
    ss.getData('line');
    // ss.getDataSatota('line');
    return Scaffold(
      appBar: AppBar(
         actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(search: ss.s));
            },
            icon: const Icon(
              Icons.search,
              weight: 50.0,
              color: Color.fromARGB(255, 82, 24, 24),
            ),
          )
        ],
        elevation: 4.0,
        title: Center(
          child: Text(
            S.of(context).Cars,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Consumer<Providers>(
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: value.s.length,
              itemBuilder: (BuildContext context, int index) {
                return CardCars(
                  name: value.s[index]['name'],
                  type: value.s[index]['type'],
                  time: value.s[index]['time'],
                  number: value.s[index]['number'],
                  from: value.s[index]['from'],
                );
              });
        },
      ),
    );
  }
}
