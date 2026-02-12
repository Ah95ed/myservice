import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/widget/Cards/CardProfessions.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/ManageListingDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeApp/app_theme.dart';

class ProfessionsScreen extends StatefulWidget {
  static const ROUTE = 'ProfessionsScreen';

  const ProfessionsScreen({super.key});

  @override
  State<ProfessionsScreen> createState() => _ProfessionsScreenState();
}

class _ProfessionsScreenState extends State<ProfessionsScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final provider = context.read<Providers>();
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      provider.configureAppBar(
        Text(
          S.of(context).professions,
          style: const TextStyle(color: AppTheme.notWhite),
        ),
      );
      provider.getData(ServiceCollectios.professions.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = shared?.getBool('isRegister') == true;
    return Consumer<Providers>(
      builder: (context, value, child) {
        return Scaffold(
          body: value.s.isEmpty
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
                      value.loadMore(ServiceCollectios.professions.name);
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
                      return CardProfessions(
                        name: (value.data[index]['name'] ?? '').toString(),
                        nameProfession:
                            (value.data[index]['nameProfession'] ?? '')
                                .toString(),
                        onPressed: () {
                          context.read<Providers>().callNumber(
                            (value.data[index]['number'] ?? '').toString(),
                          );
                        },
                        onEdit:
                            isRegister && value.data[index]['canManage'] == 1
                            ? () async {
                                await ManageListingDialog.showEditDialog(
                                  context: context,
                                  collection:
                                      ServiceCollectios.professions.name,
                                  item: Map<String, dynamic>.from(
                                    value.data[index],
                                  ),
                                  onCompleted: () => value.getData(
                                    ServiceCollectios.professions.name,
                                    refresh: true,
                                  ),
                                );
                              }
                            : null,
                        onDelete:
                            isRegister && value.data[index]['canManage'] == 1
                            ? () async {
                                await ManageListingDialog.showDeleteDialog(
                                  context: context,
                                  collection:
                                      ServiceCollectios.professions.name,
                                  item: Map<String, dynamic>.from(
                                    value.data[index],
                                  ),
                                  onCompleted: () => value.getData(
                                    ServiceCollectios.professions.name,
                                    refresh: true,
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
