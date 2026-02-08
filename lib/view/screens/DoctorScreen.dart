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

class DoctorScreen extends StatefulWidget {
  static const ROUTE = "DoctorScreen";

  DoctorScreen({Key? key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final provider = context.read<Providers>();
    provider.title = Text(
      Translation[Language.doctors],
      style: const TextStyle(color: AppTheme.notWhite),
    );
    provider.actionsicon = const Icon(
      Icons.search,
      color: AppTheme.notWhite,
      size: 22.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getData('Doctor');
    });
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
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
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200) {
                      value.loadMore('Doctor');
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: value.data.length + (value.hasMore ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= value.data.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return CardViewList(
                        name: value.data[index]['name'],
                        presence: value.data[index]['presence'],
                        specialization: value.data[index]['specialization'],
                        number: value.data[index]['number'],
                        title: value.data[index]['title'],
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
