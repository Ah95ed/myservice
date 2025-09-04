import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineScreen extends StatefulWidget {
  static const Route = '/line screen';
  LineScreen({super.key});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController time = TextEditingController();

  TextEditingController typevehicle = TextEditingController();

  TextEditingController direction = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    time.dispose();
    typevehicle.dispose();
    direction.dispose();
    // TODO: implement dispose
    super.dispose();
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
                height: getheight(25),
                title: Translation[Language.Addtransmissionline],
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
                phone,
                Icons.phone,
                Translation[Language.number_phone],
                false,
                false,
              ),
              SizedBox(height: getheight(1.5)),
              component1(
                typevehicle,
                Icons.taxi_alert_rounded,
                Translation[Language.cars],
                false,
                false,
              ),
              SizedBox(height: getheight(1.5)),
              component1(
                time,
                Icons.time_to_leave,
                Translation[Language.time],
                false,
                false,
              ),
              SizedBox(height: getheight(1.5)),
              component1(
                direction,
                Icons.where_to_vote_sharp,
                Translation[Language.line],
                false,
                false,
              ),
              SizedBox(height: getheight(2)),
              CustomMaterialButton(
                title: Translation[Language.send],
                onPressed: () async {
                  if (name.text.isEmpty ||
                      phone.text.isEmpty ||
                      typevehicle.text.isEmpty ||
                      time.text.isEmpty ||
                      direction.text.isEmpty) {
                    showSnakeBar(context, Translation[Language.fields]);
                    return;
                  }
                  // ! her to send data
                  // * so u need service controller and modele to all service ;
                  read.setDataInFirestore(
                    context,
                    ServiceCollectios.line.name,
                    {
                      "name": name.text,
                      "number": phone.text,
                      "time": time.text,
                      "type": typevehicle.text,
                      "from": direction.text,
                      "bool": true,
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
