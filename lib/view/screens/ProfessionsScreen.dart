import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/ServiceCollectios.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardProfessions.dart';

class ProfessionsScreen extends StatelessWidget {
  static const ROUTE = 'ProfessionsScreen';

  const ProfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.professions.name);
    context.read<Providers>().title = Text(S.current.professions);
      context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(S.current.professions);
                },
                icon: Icon(value.actionsicon.icon),
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
