import 'package:Al_Zab_township_guide/controller/provider/DoctorProvider/DoctorProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/cardView.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/constant/app_theme.dart';

class DoctorScreen extends StatelessWidget {
  static const ROUTE = "DoctorScreen";

  DoctorScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    MyApp.getContext()!.read<DoctorProvider>().getDataAll();
    context.read<Providers>().title = Text(
      S.of(context).doctor,
      style: const TextStyle(
        color: AppTheme.notWhite,
      ),
    );
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<DoctorProvider>(
      builder: (context, value, child) {
        return Scaffold(
          drawer: Customdrawer(),
        body: value.doctors!.isEmpty
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
                  itemCount: value.doctors!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardViewList(
                      name: value.doctors![index].name,
                      presence: value.doctors![index].presence,
                      specialization: value.doctors![index].specialization,
                      number: value.doctors![index].name,
                      title: value.doctors![index].title,
                    );
                  },
                ),
        );
      },
    );
  }
}
