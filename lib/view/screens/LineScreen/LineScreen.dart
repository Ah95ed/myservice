import 'package:Al_Zab_township_guide/Helper/Constant/ServiceCollectios.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineScreen extends StatelessWidget {
  static const Route = '/line screen';
  LineScreen({super.key});
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController typevehicle = TextEditingController();
  TextEditingController direction = TextEditingController();
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
                phone,
                Icons.phone,
                Translation[Language.number_phone],
                false,
                false,
              ),
              SizedBox(
                height: getheight(1.5),
              ),
              component1(
                typevehicle,
                Icons.taxi_alert_rounded,
                Translation[Language.cars],
                false,
                false,
              ),
              SizedBox(
                height: getheight(1.5),
              ),
              component1(
                time,
                Icons.time_to_leave,
                Translation[Language.time],
                false,
                false,
              ),
              SizedBox(
                height: getheight(1.5),
              ),
              component1(
                direction,
                Icons.where_to_vote_sharp,
                Translation[Language.line],
                false,
                false,
              ),
              SizedBox(
                height: getheight(2),
              ),
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

class LogoService extends StatelessWidget {
  LogoService({
    this.height,
    super.key,
  });
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getheight(4),
      ),
      height: height,
      width: getWidth(100),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 5),
            blurRadius: 4,
            color: ColorUsed.primary,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            ColorUsed.primary,
            ColorUsed.second,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: getheight(10),
            child: Image.asset(
              "assets/logo/asd.png",
            ),
          ),
          SizedBox(
            height: getheight(2),
          ),
          Text(
            "إضافة خط النقل",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: setFontSize(16),
              fontWeight: FontWeight.bold,
              color: AppTheme.notWhite,
              fontFamily: "Cairo",
            ),
          ),
        ],
      ),
    );
  }
}
