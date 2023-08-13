import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tester_app/Models/provider/Provider.dart';
import '../widget/constant/Constant.dart';
import '../widget/constant/InfoGroup.dart';

class WhoCanDonateScreen extends StatelessWidget {
  static const route = 'who-can-donate';

  const WhoCanDonateScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Who Can Donate Blood ?')),
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
                              title: Text(c),
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
                  child: const Icon(Icons.co2),
                  // text: 'Learn More',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
