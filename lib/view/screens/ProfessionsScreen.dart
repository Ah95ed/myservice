import 'package:Al_Zab_township_guide/Helper/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardProfessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widget/constant/Constant.dart';
import '../widget/constant/app_theme.dart';

class ProfessionsScreen extends StatelessWidget {
  static const ROUTE = 'ProfessionsScreen';

  const ProfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<Providers>().getData(ServiceCollectios.professions.name);
    context.read<Providers>().title = Text(
      S.current.professions,
      style: const TextStyle(color: AppTheme.notWhite),
    );
    context.read<Providers>().actionsicon = const Icon(Icons.search);
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 5.0,
            toolbarHeight: getheight(8),
            actions: [
              IconButton(
                onPressed: () {
                  value.changewidget(
                      S.of(context).professions,
                      const TextStyle(
                        color: AppTheme.notWhite,
                      ));
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
                    // return const ImageListView(startIndex: 0);
                    return CardProfessions(
                      name: value.s[index]['name'],
                      nameProfession: value.s[index]['nameProfession'],
                      onPressed: () {
                        context
                            .read<Providers>()
                            .callNumber(value.s[index]['number']);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
