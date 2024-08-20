import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSatota extends StatefulWidget {
  static const String Route = "/AddSatota";

  @override
  State<AddSatota> createState() => _AddSatotaState();
}

class _AddSatotaState extends State<AddSatota> {
  TextEditingController name = TextEditingController();

  TextEditingController title = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    title.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<ServiceController>();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          height: getheight(100),
          color: ColorUsed.PrimaryBackground,
          width: getWidth(100),
          child: Column(
            children: [
              LogoService(
                height: getheight(30),
                title: Translation[Language.AddDoctor],
              ),
              SizedBox(
                height: getheight(4),
              ),
              component1(
                name,
                Icons.person,
                Translation[Language.please_enter_name],
                false,
                false,
              ),
              SizedBox(
                height: getheight(1.5),
              ),
              component1(
                title,
                Icons.title,
                Translation[Language.locationWork],
                false,
                false,
              ),
              SizedBox(
                height: getheight(2),
              ),
              CustomMaterialButton(
                title: Translation[Language.send],
                onPressed: () async {
                  if (name.text.isEmpty || title.text.isEmpty) {
                    showSnakeBar(context, Translation[Language.fields]);
                    return;
                  }
                  if (await shared!.getString('phoneUser') == null) return;
                  read.setDataInFirestore(
                    context,
                    ServiceCollectios.Satota.name,
                    {
                      "name": name.text,
                      'number': await shared!.getString('phoneUser'),
                      "location": title.text,
                      'token': DateTime.now().toString(),
                    },
                  );

                  await showCirculerProgress(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
