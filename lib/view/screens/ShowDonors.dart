import 'package:Al_Zab_township_guide/controller/Constant/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardDonors.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widget/constant/Constant.dart';

// ignore: must_be_immutable
class ShowDonors extends StatelessWidget {
  static const ROUTE = 'ShowDonors';

  const ShowDonors({super.key});

  @override
  Widget build(BuildContext context) {
    DataSend? dataSend = ModalRoute.of(context)!.settings.arguments as DataSend;
    context.read<Providers>().title = Text(
      S.of(context).donors,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    context.read<Providers>().getData(dataSend.collection);
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 5.0,
              toolbarHeight: 10.h,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppTheme.notWhite,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    value.changewidget(
                      S.of(context).donors,
                      const TextStyle(
                        color: AppTheme.notWhite,
                      ),
                    );
                  },
                  icon: Icon(
                    value.actionsicon.icon,
                    color: AppTheme.notWhite,
                  ),
                )
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
                      return CardDonors(
                        name: value.s[index]['name'],
                        type: dataSend.collection,
                        title: value.s[index]['location'],
                        number: value.s[index]['number'],
                      );
                    },
                  ));
      },
    );
  }
}
