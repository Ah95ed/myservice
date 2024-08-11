import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardProfessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/constant/app_theme.dart';

class ProfessionsScreen extends StatelessWidget {
  static const ROUTE = 'ProfessionsScreen';

  const ProfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.professions.name);
    context.read<Providers>().title = Text(
      S.of(context).professions,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    context.read<Providers>().actionsicon = const Icon(Icons.search);
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
                      Text(S.of(context).wait_service)
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.s.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return const ImageListView(startIndex: 0);
                    return CardProfessions(
                      name: value.s[index]['name'],
                      nameProfession: value.s[index]['nameProfession'],
                      onPressed: () {
                        context
                            .read<Providers>()
                            .callNumber(value.s[index]['number']);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
