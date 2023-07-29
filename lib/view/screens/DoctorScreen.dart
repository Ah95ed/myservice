import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tester_app/generated/l10n.dart';
import 'package:tester_app/view/widget/cardView.dart';
import '../../controller/Constant/ServiceCollectios.dart';
import '../../Models/provider/Provider.dart';

class DoctorScreen extends StatelessWidget {

  static const ROUTE = "SecondScreen";

  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.Doctor.name);
    context.read<Providers>().title = Text(S.of(context).doctor);
      context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 4.0,
            title: value.title,
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(S.of(context).doctor);
                },
                icon: Icon(
                  value.actionsicon.icon,
                ),
              )
            ],
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
                    return CardViewList(
                      name: value.s[index]['name'],
                      presence: value.s[index]['presence'],
                      specialization: value.s[index]['specialization'],
                      number: value.s[index]['number'],
                      title: value.s[index]['title'],
                    );
                  },
                ),
        );
      },
    );
  }
}
