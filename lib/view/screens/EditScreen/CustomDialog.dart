import 'package:Al_Zab_township_guide/Helper/Log/Logger.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/controller/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/controller/provider/OTPEmailProvider/OTPEmailProvider.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/main.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedValue;
  TextEditingController _textController = TextEditingController();
  Providers? read;

  @override
  Widget build(BuildContext context) {
    read = context.read<Providers>();

    return AlertDialog(
      title: Text(
        S.current.edit_Data_and_delete,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedValue,
              hint: Text(
                S.current.Select_Service,
                style: TextStyle(
                  color: ColorUsed.second,
                  fontSize: setFontSize(14),
                ),
              ),
              onChanged: (newValue) {
                _selectedValue = newValue;
                setState(() {
                  // _selectedValue = newValue;
                });
              },
              items: <String>[
                S.current.doctor,
                S.current.blood_type,
                S.current.Cars,
                S.current.professions,
                S.current.internal_transfer,
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              validator: (value) =>
                  value == null ? S.current.please_select_an_option : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _textController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: S.current.number_phone,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.please_enter_phone;
                }
                return null;
              },
            ),
            SizedBox(
              height: getheight(2.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.current.cancel,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedValue!.contains(S.current.doctor)) {
                      _selectedValue = 'Doctor';
                      searchService(_selectedValue);
                      Navigator.of(context).pop();
                    } else if (_selectedValue == S.current.blood_type) {
                      searchTypes(_textController.text);
                      Navigator.of(context).pop();

                      // _selectedValue = ServiceCollectios.line.name;
                    } else if (_selectedValue == S.current.Cars) {
                      _selectedValue = 'line';
                      searchService(_selectedValue);
                    } else if (_selectedValue == S.current.professions) {
                      _selectedValue = 'professions';
                      searchService(_selectedValue);
                    } else if (_selectedValue == S.current.internal_transfer) {
                      _selectedValue = 'Satota';
                      searchService(_selectedValue);
                    }
                  },
                  child: Text(S.current.confirm),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        Center(
          child: Text(S.current.go_to_developer_page),
        ),
        SizedBox(
          height: getheight(2),
        ),
        Center(
          child: CustomMaterialButton(
            title: S.current.send_developer,
            onPressed: () {
               Navigator.of(context).pop();
              read!.managerScreen(MessageDeveloper.Route, context);
              // Navigator.of(context).pop();
            },
          ),
        )
      ],
      // actionsAlignment: MainAxisAlignment.center,
    );
  }

  List<String> types = [
    Constant.A_Plus,
    Constant.A_Minus,
    Constant.B_Plus,
    Constant.B_Minus,
    Constant.O_Plus,
    Constant.O_Minus,
    Constant.AB_Plus,
    Constant.AB_Minus
  ];

  @override
  void dispose() {
    _textController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  void searchTypes(String n) async {
    if (shared!.getInt('num') == null) {
      shared!.setInt('num', 1);
    } else {
      int? nshaerd = shared!.getInt('num');
      shared!.setInt('num', nshaerd! + 1);
    }

    for (var e in types) {
      CollectionReference querySnapshot =
          await FirebaseFirestore.instance.collection(e);
      querySnapshot.get().then(
        (r) {
          for (var element in r.docs) {
            if (n == element.get('number')) {
              context.read<OTPEmailProvider>().sendCode(n);
              break;
            }
            context.read<OTPEmailProvider>().sendCode(n);
            break;
          }
        },
      );
    }
  }

  void searchService(String? selectedValue) async {
    CollectionReference querySnapshot =
        await FirebaseFirestore.instance.collection(selectedValue!);
    querySnapshot.where('number', isEqualTo: _textController.text).get().then(
      (value) async {
        value.docs.map((v) {
          if (v.exists) {
            context.read<OTPEmailProvider>().sendCode(v.get('number'));
            return;
          }
          ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
            SnackBar(content: Text(S.current.not_phond_found)),
          );
          Logger.logger('message: value ${v.get('number')}');
        }).toList();
        // return value;
      },
      onError: (e) {
        ScaffoldMessenger.of(MyApp.getContext()!).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      },
    );
  }
}
