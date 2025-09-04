import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardCars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/app_theme.dart';

class TheCars extends StatelessWidget {
  static const ROUTE = 'TheCars';

  const TheCars({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.line.name);
    context.read<Providers>().title = Text(
      S.of(context).cars,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    context.read<Providers>().actionsicon = const Icon(
      Icons.search,
      color: AppTheme.notWhite,
      size: 22.0,
    );
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          body: value.data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: getWidth(2)),
                      Text(S.of(context).wait_service),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: value.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardCars(
                      name: value.data[index]['name'],
                      type: value.data[index]['type'] ?? 'غيرمعرف',
                      time: value.data[index]['time'],
                      number: value.data[index]['number'],
                      from: value.data[index]['from'],
                    );
                  },
                ),
        );
      },
    );
  }
}
