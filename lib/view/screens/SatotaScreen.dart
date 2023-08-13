import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/ServiceCollectios.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/Card_Satota.dart';

class SatotaScreen extends StatefulWidget {
  static const ROUTE = '/SatotaScreen';
  const SatotaScreen({super.key});

  @override
  State<SatotaScreen> createState() => _SatotaScreenState();
}

class _SatotaScreenState extends State<SatotaScreen> {
  late BuildContext c;

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.Satota.name);
    context.read<Providers>().title = Text(S.of(context).internal_transfer);
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    c = context;
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(
                    S.of(context).internal_transfer.toString(),
                  );
                },
                icon: Icon(
                  value.actionsicon.icon,
                ),
              ),
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
                    return CardSatota(
                      name: value.s[index]['name'],
                      location: value.s[index]['location'],
                      onPressed: () {
                        value.callNumber(
                          value.s[index]['number'],
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
