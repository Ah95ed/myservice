import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
//         final account = Account(client!);

// final token = await account.createPhoneToken(
//     userId: ID.unique(),
//     phone: '+9647824854526'
// );

// final userId = token.userId;
                    showDialog(
                        barrierDismissible: false,
                        
                        useSafeArea: false,
                        context: context,
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        });
                  },
                  child: Text('click herer'))
            ],
          ),
        ),
      ),
    );
  }
}
