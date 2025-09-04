import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/cardView.dart';
import 'package:Al_Zab_township_guide/view/widget/Drawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/app_theme.dart';

class DoctorScreen extends StatelessWidget {
  static const ROUTE = "DoctorScreen";

  DoctorScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData('Doctor');
    context.read<Providers>().title = Text(
      Translation[Language.doctors],
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
          drawer: Customdrawer(),
          body: value.data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: getheight(2)),
                      Text(S.of(context).wait_service),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardViewList(
                      name: value.data[index]['name'],
                      presence: value.data[index]['presence'],
                      specialization: value.data[index]['specialization'],
                      number: value.data[index]['number'],
                      title: value.data[index]['title'],
                    );
                  },
                ),
        );
      },
    );
  }
}
