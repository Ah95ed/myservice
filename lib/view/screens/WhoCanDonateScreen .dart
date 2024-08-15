import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ThemeApp/ColorUsed.dart';
import '../../Models/constant/InfoGroup.dart';
import '../ThemeApp/app_theme.dart';

class WhoCanDonateScreen extends StatelessWidget {
  static const route = 'who-can-donate';

  const WhoCanDonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 3.0,
        toolbarHeight: getheight(8),
        actions: const [],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.nearlyWhite,
            size: 24,
          ),
        ),
        title: Text(
          S.of(context).whocandonate,
          style: TextStyle(
            color: AppTheme.white,
            fontSize: setFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [ColorUsed.primary, ColorUsed.second,],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...InfoGroup.whoCanDonate
                  .map(
                    (g) => ExpansionTile(
                      title: Text(
                        g.title!,
                      ),
                      initiallyExpanded: g.id == 0,
                      children: g.info!
                          .map(
                            (c) => ListTile(
                              leading: const Icon(Icons.bookmark),
                              title: Text(
                                c,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: setFontSize(10),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    // context.read<Providers>().launchInBrowser(
                    //     Uri.parse(AppConfig.bloodDonationInfoLink));
                  },
                  child: Row(
                    children: [
                      Text(
                        S.of(context).source,
                      ),
                      const Spacer(),
                      const Icon(Icons.source_outlined),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
