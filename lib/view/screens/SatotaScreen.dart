import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/Card_Satota.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/app_theme.dart';

class SatotaScreen extends StatelessWidget {
  static const ROUTE = '/SatotaScreen';
  const SatotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.Satota.name);
    context.read<Providers>().title = Text(
      S.of(context).internal_transfer,
      style: const TextStyle(
        color: AppTheme.notWhite,
      ),
    );
    context.read<Providers>().actionsicon = const Icon(
      Icons.search,
      color: AppTheme.notWhite,
      size: 22.0,
    );

    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          body: value.s.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: getheight(2),
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
