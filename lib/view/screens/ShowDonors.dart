import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/Constant.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardDonors.dart';

// ignore: must_be_immutable
class ShowDonors extends StatelessWidget {
  static const ROUTE = 'ShowDonors';

  const ShowDonors({super.key});

  @override
  Widget build(BuildContext context) {
    DataSend? dataSend = ModalRoute.of(context)!.settings.arguments as DataSend;
    context.read<Providers>().title = Text(S.of(context).donors);
    context.read<Providers>().getData(dataSend.collection);
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(S.of(context).donors);
                },
                icon: Icon(value.actionsicon.icon),
              )
            ],
            title: value.title,
            elevation: 4.0,
          ),
          body: value.s.isEmpty
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
                  itemCount: value.s.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardDonors(
                      name: value.s[index]['name'],
                      type: dataSend.collection,
                      title: value.s[index]['location'],
                      number: value.s[index]['number'],
                    );
                  },
                ),
        );
      },
    );
  }
}
