import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDoctor extends StatefulWidget {
  static const String Route = "/AddDoctor";

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  TextEditingController name = TextEditingController();

  TextEditingController Specialization = TextEditingController();

  TextEditingController time = TextEditingController();

  TextEditingController title = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    Specialization.dispose();
    time.dispose();
    title.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<ServiceController>();
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: SingleChildScrollView(
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
                SizedBox(height: getheight(4)),
                component1(
                  name,
                  Icons.person,
                  Translation[Language.please_enter_name],
                  false,
                  false,
                ),
                SizedBox(height: getheight(1.5)),
                component1(
                  Specialization,
                  Icons.type_specimen,
                  Translation[Language.specialization],
                  false,
                  false,
                ),
                SizedBox(height: getheight(1.5)),
                component1(
                  time,
                  Icons.access_time_sharp,
                  Translation[Language.time],
                  false,
                  false,
                ),
                SizedBox(height: getheight(1.5)),
                component1(
                  title,
                  Icons.title,
                  Translation[Language.doctor_title],
                  false,
                  false,
                ),
                SizedBox(height: getheight(2)),
                CustomMaterialButton(
                  title: Translation[Language.send],
                  onPressed: () async {
                    if (name.text.isEmpty ||
                        Specialization.text.isEmpty ||
                        time.text.isEmpty ||
                        title.text.isEmpty) {
                      showSnakeBar(context, Translation[Language.fields]);
                      return;
                    }
                    // ! her to send data
                    // * so u need service controller and modele to all service ;
                    read.setDataInFirestore(
                      context,
                      ServiceCollectios.Doctor.name,
                      {
                        "name": name.text,
                        'number': await shared!.getString('phoneUser'),
                        'specialization': Specialization.text,
                        "presence": time.text,
                        "title": title.text,
                        'bool': true,
                      },
                    );

                    await showCirculerProgress(context);
                    // name.dispose();
                    // Specialization.dispose();
                    // time.dispose();
                    // title.dispose();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
