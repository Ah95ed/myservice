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

class AddProfessions extends StatelessWidget {
  static const Route = '/AddProfessions';
  AddProfessions({super.key});
  TextEditingController name = TextEditingController();
  TextEditingController nameProfession = TextEditingController();
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
                title: Translation[Language.professions],
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
                nameProfession,
                Icons.work_history,
                Translation[Language.typeProfession],
                false,
                false,
              ),
              SizedBox(
                height: getheight(2),
              ),
              CustomMaterialButton(
                title: Translation[Language.send],
                onPressed: () async {
                  if (name.text.isEmpty || nameProfession.text.isEmpty) {
                    showSnakeBar(context, Translation[Language.fields]);
                    return;
                  }
                  // ! her to send data
                  // * so u need service controller and modele to all service ;
                  read.setDataInFirestore(
                    context,
                    ServiceCollectios.professions.name,
                    {
                      "name": name.text,
                      "nameProfession": nameProfession.text,
                      'number':await shared!.getString('phoneUser'),
                      "token": DateTime.now().toString(),
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
