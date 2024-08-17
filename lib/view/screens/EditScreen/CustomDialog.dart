import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
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

  @override
  Widget build(BuildContext context) {
    final read = context.read<Updateprovider>();
    final providers = context.read<Providers>();
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
                S.current.select_service,
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
                S.current.cars,
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
                  autofocus: true,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUsed.second,
                    foregroundColor: ColorUsed.second,
                    shadowColor: ColorUsed.second,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: ColorUsed.second,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.current.cancel,
                    style: TextStyle(
                      fontSize: setFontSize(16),
                      color: AppTheme.notWhite,
                    ),
                  ),
                ),
                ElevatedButton(
                  autofocus: true,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUsed.second,
                    foregroundColor: ColorUsed.second,
                    shadowColor: ColorUsed.second,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: ColorUsed.second,
                    ),
                  ),
                  onPressed: () async {
                    if (_selectedValue!
                        .contains(Translation[Language.doctor])) {
                      _selectedValue = 'Doctor';
                      read.searchService(
                        _selectedValue!,
                        _textController.text,
                        context,
                      );
                    } else if (_selectedValue ==
                        Translation[Language.blood_type]) {
                      await read.searchTypes(context, _textController.text);
                      // Navigator.of(context).pop();

                      // _selectedValue = ServiceCollectios.line.name;
                    } else if (_selectedValue == S.current.cars) {
                      _selectedValue = 'line';
                      await read.searchService(
                        _selectedValue!,
                        _textController.text,
                        context,
                      );
                    } else if (_selectedValue == S.current.professions) {
                      _selectedValue = 'professions';
                      read.searchService(
                        _selectedValue!,
                        _textController.text,
                        context,
                      );
                    } else if (_selectedValue == S.current.internal_transfer) {
                      _selectedValue = 'Satota';
                      read.searchService(
                        _selectedValue!,
                        _textController.text,
                        context,
                      );
                    }
                  },
                  child: Text(
                    S.current.confirm,
                    style: TextStyle(
                      fontSize: setFontSize(16),
                      color: AppTheme.notWhite,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        Center(
          child: Text(
            S.current.go_to_developer_page,
            style: TextStyle(
              fontSize: setFontSize(16),
              color: ColorUsed.DarkGreen,
            ),
          ),
        ),
        SizedBox(
          height: getheight(2),
        ),
        Center(
          child: CustomMaterialButton(
            title: S.current.send_developer,
            onPressed: () {
              Navigator.of(context).pop();
              providers.managerScreen(MessageDeveloper.Route, context);
              // Navigator.of(context).pop();
            },
          ),
        )
      ],
      // actionsAlignment: MainAxisAlignment.center,
    );
  }

  // @override
  // void dispose() {
  //   _textController.dispose();
  //   super.dispose();
  // }
}
