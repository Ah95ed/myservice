import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tester_app/controller/Constant/Constant.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardDonors.dart';

import '../../controller/Constant/CustomSearchDelegate.dart';

// ignore: must_be_immutable
class ShowDonors extends StatelessWidget {
  static const ROUTE = 'ShowDonors';

  @override
  Widget build(BuildContext context) {
    final dataSend = ModalRoute.of(context)!.settings.arguments as DataSend;
    final ss = Provider.of<Providers>(context, listen: false);
    ss.getData(dataSend.collection);

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
          title: Center(
            child: Text(
              S.of(context).donors,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 4.0,
        ),
        body: Consumer<Providers>(
          builder: (context, data, child) {
            return ss.s.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: data.s.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardDonors(
                        name: data.s[index]['name'],
                        type: dataSend.collection,
                        title: data.s[index]['location'],
                        number: data.s[index]['number'],
                      );
                    });
          },
        ));
  }
}
