import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/cardView.dart';
import '../../controller/Constant/CustomSearchDelegate.dart';
import '../../controller/Constant/ServiceCollectios.dart';
import '../../Models/provider/Provider.dart';

class DoctorScreen extends StatelessWidget {
  static const ROUTE = "SecondScreen";

  const DoctorScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ss = Provider.of<Providers>(context, listen: false);
    ss.getData(ServiceCollectios.Doctor.name);

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: Text(S.of(context).Doctor),
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
      ),
      body: Consumer<Providers>(
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: value.s.length,
              itemBuilder: (BuildContext context, int index) {
                // return const ImageListView(startIndex: 0);
                return CardViewList(
                  name: value.s[index]['name'],
                  presence: value.s[index]['presence'],
                  specialization: value.s[index]['specialization'],
                  number: value.s[index]['number'],
                  title: value.s[index]['title'],
                );
              });
        },
      ),
    );
  }
}
