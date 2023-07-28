import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/Constant.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardDonors.dart';

import '../../controller/Constant/CustomSearchDelegate.dart';

// ignore: must_be_immutable
class ShowDonors extends StatelessWidget {
  static const ROUTE = 'ShowDonors';

  const ShowDonors({super.key});

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
        body: Selector<Providers, List>(
          selector: (p0, p1) => p1.s,
          builder: (context, data, child) {
            return data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(S.of(context).wait_service)
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardDonors(
                        name: data[index]['name'],
                        type: dataSend.collection,
                        title: data[index]['location'],
                        number: data[index]['number'],
                      );
                    });
          },
        ));
  }
}
