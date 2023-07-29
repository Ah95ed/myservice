import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/ServiceCollectios.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardCars.dart';

class TheCars extends StatelessWidget {

  static const ROUTE = 'TheCars';

  const TheCars({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.line.name);
    context.read<Providers>().title = Text(S.of(context).Cars);
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(S.of(context).Cars);
                },
                icon: Icon(
                  value.actionsicon.icon,
                ),
              )
            ],
            elevation: 4.0,
            title: value.title,
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
                      Text(S.of(context).wait_service),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.s.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardCars(
                      name: value.s[index]['name'],
                      type: value.s[index]['type'],
                      time: value.s[index]['time'],
                      number:value.s[index]['number'],
                      from: value.s[index]['from'],
                    );
                  },
                ),
        );
      },
    );
  }
}
