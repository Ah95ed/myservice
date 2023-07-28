import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/controller/Constant/ServiceCollectios.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/CardProfessions.dart';

import '../../controller/Constant/CustomSearchDelegate.dart';

class ProfessionsScreen extends StatelessWidget {
  static const ROUTE = 'ProfessionsScreen';

  const ProfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ss = Provider.of<Providers>(context, listen: false);
    ss.getData(ServiceCollectios.professions.name);

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
            S.of(context).professions,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Selector<Providers,List>(
        selector: (p0, p1) => p1.s,
        builder: (context, value, child) {
          return value.isEmpty
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
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                // return const ImageListView(startIndex: 0);
                return CardProfessions(
                  name: value[index]['name'],
                  nameProfession: value[index]['nameProfession'],
                  onPressed: () {
                    context
                        .read<Providers>()
                        .callNumber(value[index]['number']);
                  },
                );
              });
        },
      ),
    );
  }
}
