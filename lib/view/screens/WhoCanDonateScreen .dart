import 'package:Al_Zab_township_guide/Models/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widget/constant/Constant.dart';
import '../widget/constant/InfoGroup.dart';
import '../widget/constant/app_theme.dart';

class WhoCanDonateScreen extends StatelessWidget {
  static const route = 'who-can-donate';

  const WhoCanDonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        toolbarHeight: 10.h,
        actions: const [],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.nearlyWhite,
            size: 24,
          ).animate().addEffect(
                const MoveEffect(
                  begin: Offset(0.0, 10),
                  duration: Duration(milliseconds: 500),
                  delay: Duration(milliseconds: 200),
                  curve: Curves.linear,
                ),
              ),
        ),
        title: Text(
          S.of(context).whocandonate,
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ).animate().addEffect(
              const MoveEffect(
                begin: Offset(0.0, 10),
                duration: Duration(milliseconds: 500),
                delay: Duration(milliseconds: 200),
                curve: Curves.linear,
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
              colors: [ColorUsed.primary, ColorUsed.second],
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
                                    fontSize: 10.sp),
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
                    context.read<Providers>().launchInBrowser(
                        Uri.parse(AppConfig.bloodDonationInfoLink));
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
      ).animate().addEffect(
            const MoveEffect(
              begin: Offset(0.0, 10),
              duration: Duration(milliseconds: 500),
              delay: Duration(milliseconds: 200),
              curve: Curves.linear,
            ),
          ),
    );
  }
}
