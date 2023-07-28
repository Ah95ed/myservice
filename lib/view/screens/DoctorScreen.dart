import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
      body: Selector<Providers,List>(
        selector: (p0, p1) => p1.s,
        builder: (context, value, child) {
          return value.isEmpty ?
          Center(
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
          ) : ListView.builder(
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                // return const ImageListView(startIndex: 0);
                return CardViewList(
                  name: value[index]['name'],
                  presence: value[index]['presence'],
                  specialization: value[index]['specialization'],
                  number: value[index]['number'],
                  title: value[index]['title'],
                );
              });
        },
      ),
    );
  }
}
