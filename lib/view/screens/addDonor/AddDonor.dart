import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/controller/provider/ServiceController/ServiceController.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/LoginScreen/login_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/LoginWidget/Loginimageshow.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDonor extends StatefulWidget {
  static const String Route = "/AddDonor";

  @override
  State<AddDonor> createState() => _AddDonorState();
}

class _AddDonorState extends State<AddDonor> {
  TextEditingController name = TextEditingController();

  TextEditingController location = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    location.dispose();
  }

  String? dropdownValue;

  List<String> items = [
    Constant.A_Plus,
    Constant.A_Minus,
    Constant.B_Plus,
    Constant.B_Minus,
    Constant.O_Plus,
    Constant.O_Minus,
    Constant.AB_Plus,
    Constant.AB_Minus,
  ];

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
              Container(
                height: getheight(7),
                width: getWidth(90),
                padding: EdgeInsets.symmetric(
                  horizontal: getWidth(2),
                ),
                decoration: BoxDecoration(
                  color: ColorUsed.second.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text(
                    Translation[Language.selectType],
                    style: TextStyle(
                      fontSize: setFontSize(14),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.notWhite,
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: setFontSize(14),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkerText,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: getheight(2),
              ),
              component1(
                location,
                Icons.title,
                Translation[Language.location],
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
                  location.text.isEmpty||
                  dropdownValue==null) {
                    showSnakeBar(context, Translation[Language.fields]);
                    return;
                  }
                  if (await shared!.getString('phoneUser') == null) return;
                  read.setDataInFirestore(
                    context,
                    dropdownValue!,
                    {
                      "name": name.text,
                      'number': await shared!.getString('phoneUser'),
                      "location": location.text,
                      'type': dropdownValue,
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
