import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardDonors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/ColorUsed.dart';

// ignore: must_be_immutable
class ShowDonors extends StatefulWidget {
  static const ROUTE = 'ShowDonors';

  const ShowDonors({super.key});

  @override
  State<ShowDonors> createState() => _ShowDonorsState();
}

class _ShowDonorsState extends State<ShowDonors> {
  DataSend? _dataSend;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _dataSend = ModalRoute.of(context)!.settings.arguments as DataSend;
    final provider = context.read<Providers>();
    provider.title = Text(
      S.of(context).donors,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    provider.actionsicon = const Icon(Icons.search);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getData(_dataSend!.collection);
    });
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final dataSend = _dataSend;
    if (dataSend == null) {
      return const SizedBox.shrink();
    }
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 5.0,
            toolbarHeight: getheight(10),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: AppTheme.notWhite),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(
                    // S.of(context).donors,
                    const TextStyle(color: AppTheme.notWhite),
                  );
                },
                icon: Icon(value.actionsicon.icon, color: AppTheme.notWhite),
              ),
            ],
            title: value.title,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [ColorUsed.primary, ColorUsed.second],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
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
              : SizedBox(
                  height: getheight(100),
                  width: getWidth(100),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 200) {
                        value.loadMore(dataSend.collection);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: value.data.length + (value.hasMore ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= value.data.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return CardDonors(
                          name: value.data[index]['name'],
                          type: dataSend.collection,
                          title: value.data[index]['location'],
                          number: value.data[index]['number'],
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }
}
