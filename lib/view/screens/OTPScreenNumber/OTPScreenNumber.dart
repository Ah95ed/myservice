import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPScreenNumber extends StatefulWidget {
  OTPScreenNumber({super.key});
  static const Route = '/OTPScreenNumber';

  @override
  State<OTPScreenNumber> createState() => _OTPScreenNumberState();
}

class _OTPScreenNumberState extends State<OTPScreenNumber> {
  TextEditingController _textController = TextEditingController();

  late String userId;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    super.initState();
    userId = shared!.getString('userId') ?? "a";
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<Updateprovider>();

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: getheight(30),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
                color: ColorUsed.primary, // Color(0xFF501063),
                gradient: LinearGradient(
                  colors: [
                    ColorUsed.primary,
                    ColorUsed.second,
                    // (Color(0xFF501063)),
                    // (Color(0xFF591D6B)),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: getheight(6),
                      ),
                      height: getheight(12),
                      child: Image.asset(
                        'assets/logo/asd.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getheight(2),
            ),
            Text(
              Translation[Language.inter_otp_number],
              style: TextStyle(
                fontSize: setFontSize(14),
                fontWeight: FontWeight.bold,
                color: ColorUsed.second,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: getheight(6),
            ),
            SizedBox(
              height: getheight(10),
              width: getWidth(70),
              child: AspectRatio(
                aspectRatio: 0.5,
                child: TextField(
                  controller: _textController,
                  autofocus: true,
                  showCursor: true,
                  // readOnly: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: setFontSize(14),
                    fontWeight: FontWeight.bold,
                    color: ColorUsed.second,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counter: const Offstage(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: ColorUsed.primary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: ColorUsed.primary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getheight(6),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: ColorUsed.primary,
                foregroundColor: ColorUsed.primary,
                shadowColor: ColorUsed.primary,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(
                  color: ColorUsed.second,
                ),
              ),
              onPressed: () async {
                if (_textController.text.isEmpty) {
                  showSnakeBar(
                    context,
                    Translation[Language.fields],
                  );
                  return;
                }
                if (_textController.text.length < 4 ||
                    _textController.text.length > 4) {
                  showSnakeBar(
                    context,
                    Translation[Language.just4],
                  );
                  return;
                }
                Client client = await Client();
                await client
                    .setEndpoint('https://cloud.appwrite.io/v1')
                    .setProject('66b5930400399d8fd3ee')
                    .setSelfSigned(status: true);
                final account = await Account(client);

                await account
                    .createSession(
                  userId: userId,
                  secret: _textController.text,
                )
                    .then(
                  (value) {
                    if (value.current) {
                      showDialog(
                        context: context,
                        builder: (c) {
                          return AlertDialog(
                            title: Text(
                              Translation[Language.sure_to_delete_account],
                            ),
                            actions: [
                              ElevatedButton(
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUsed.primary,
                                  foregroundColor: ColorUsed.primary,
                                  shadowColor: ColorUsed.primary,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: ColorUsed.primary,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  showCirculerProgress(context);
                                  shared!.remove('userId');
                                  await read.deleteDataFromRealtimeAndFireStore(
                                      context);
                                  // showDi
                                },
                                child: Text(
                                  Translation[Language.yes],
                                  style: TextStyle(
                                      color: AppTheme.notWhite,
                                      fontSize: setFontSize(14)),
                                ),
                              ),
                              SizedBox(
                                width: getWidth(8),
                              ),
                              ElevatedButton(
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUsed.primary,
                                  foregroundColor: ColorUsed.primary,
                                  shadowColor: ColorUsed.primary,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: ColorUsed.primary,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  shared!.remove('userId');
                                },
                                child: Text(
                                  Translation[Language.no],
                                  style: TextStyle(
                                      color: AppTheme.notWhite,
                                      fontSize: setFontSize(14)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ).catchError(
                  (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                Translation[Language.confirm_otp],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: setFontSize(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
