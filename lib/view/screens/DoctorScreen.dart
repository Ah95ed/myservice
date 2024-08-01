import 'package:Al_Zab_township_guide/controller/provider/DoctorProvider/DoctorProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/cardView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widget/constant/Constant.dart';
import '../widget/constant/app_theme.dart';

class DoctorScreen extends StatelessWidget {
  static const ROUTE = "DoctorScreen";

  @override
  Widget build(BuildContext context) {
    final d = context.watch<DoctorProvider>().getDataAll();
    context.read<Providers>().title = Text(
      S.of(context).Doctor,
      style: const TextStyle(
        color: AppTheme.notWhite,
      ),
    );
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<DoctorProvider>(
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
                  //             value.changewidget(
                  //               S.of(context).doctor, const TextStyle(
                  //   color: AppTheme.notWhite,
                  // ),
                  //             );
                },
                icon: Icon(
                  Icons.abc,
                  color: AppTheme.notWhite,
                ),
              )
            ],
            title: Text(S.of(context).Doctor),
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
          body: value.doctors!.isEmpty
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
