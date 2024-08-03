import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/Card_Satota.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widget/constant/Constant.dart';
import '../widget/constant/app_theme.dart';

class SatotaScreen extends StatelessWidget {
  static const ROUTE = '/SatotaScreen';
  const SatotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.Satota.name);
    context.read<Providers>().title = Text(
      S.of(context).internal_transfer,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    context.read<Providers>().actionsicon = const Icon(Icons.search);
  
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 5.0,
          //   toolbarHeight: getheight(8),
        
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         value.changewidget(
          //             S.of(context).donors,
          //             const TextStyle(
          //               color: AppTheme.notWhite,
          //             ));
          //       },
          //       icon: Icon(
          //         value.actionsicon.icon,
          //         color: AppTheme.notWhite,
          //       ),
          //     )
          //   ],
          //   title: value.title,
          //   centerTitle: true,
          //   flexibleSpace: Container(
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(20),
          //         bottomRight: Radius.circular(20),
          //       ),
          //       gradient: LinearGradient(
          //         colors: [ColorUsed.primary, ColorUsed.second],
          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //       ),
          //     ),
          //   ),
          //   systemOverlayStyle: SystemUiOverlayStyle.light,
          // ),
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
                      Text(S.of(context).wait_service),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: value.s.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardSatota(
                      name: value.s[index]['name'],
                      location: value.s[index]['location'],
                      onPressed: () {
                        value.callNumber(
                          value.s[index]['number'],
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
