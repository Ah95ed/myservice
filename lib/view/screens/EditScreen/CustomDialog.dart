import 'dart:developer';

import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/provider/Provider.dart';
import 'package:Al_Zab_township_guide/controller/provider/UpdateProvider/UpdateProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/MessageDeveloper.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:Al_Zab_township_guide/view/widget/staticWidget/CustomMaterialButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final _formKey = GlobalKey<FormState>();
  List<String> items = [
    Translation[Language.doctor],
    Translation[Language.line],
    Translation[Language.blood_type],
    Translation[Language.cars],
    Translation[Language.internal_transfer],
  ];

  TextEditingController _textController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
    _emailController.dispose();
  }

  String dropdownValue = "none";
  @override
  Widget build(BuildContext context) {
    final read = context.read<Updateprovider>();
    final providers = context.read<Providers>();
    return SizedBox(
      height: getheight(80),
      child: AlertDialog(
        title: Text(Translation[Language.edit_Data_and_delete]),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDropdownMenu(
                items: items,
                selectedItem: Translation[Language.select_service],
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _textController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: S.current.number_phone),
                validator: (value) {
                  if (value == null || value.isEmpty || value == '') {
                    return Translation[Language.fields];
                  }
                  return null;
                },
              ),
              SizedBox(height: getheight(2.5)),
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
                      side: const BorderSide(color: ColorUsed.second),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
                      side: const BorderSide(color: ColorUsed.second),
                    ),
                    onPressed: () async {
                   read.sendOtpNumber(context, _textController.text);

                      if (_textController.text.isEmpty) {
                        showSnakeBar(context, Translation[Language.fields]);
                        return;
                      }
                      // showCirculerProgress(context);
                      if (dropdownValue.contains(
                        Translation[Language.doctor],
                      )) {
                        dropdownValue = 'Doctor';
                        read.searchService(
                          dropdownValue,
                          _textController.text,
                          context,
                        );
                      } else if (dropdownValue ==
                          Translation[Language.blood_type]) {
                        await read.searchTypes(context, _textController.text);
           
                      } else if (dropdownValue == S.current.cars) {
                        dropdownValue = 'line';
                  //       shared!.remove('nameUser');
                  // shared!.remove('emailUser');
                  // shared!.remove('phoneUser');
                  // shared!.remove('isRegister');
                  Scaffold.of(context).closeDrawer();
                        await read.searchService(
                          dropdownValue,
                          _textController.text,
                          context,
                        );
                      } else if (dropdownValue == S.current.professions) {
                        dropdownValue = 'professions';
                        read.searchService(
                          dropdownValue,
                          _textController.text,
                          context,
                        );
                      } else if (dropdownValue == S.current.internal_transfer) {
                        dropdownValue = 'Satota';
                        read.searchService(
                          dropdownValue,
                          _textController.text,
                          context,
                        );
                      } else if (dropdownValue == "none") {
                      
                        await read.deleteDataFromRealtime(
                          context,
                          _textController.text,
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
              ),
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
          SizedBox(height: getheight(2)),
          Center(
            child: CustomMaterialButton(
              title: S.current.send_developer,
              onPressed: () {
                Navigator.pop(context);
                providers.managerScreen(MessageDeveloper.Route, context);
                // Navigator.of(context).pop();
              },
            ),
          ),
        ],
        // actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class CustomDropdownMenu extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onChanged;

  const CustomDropdownMenu({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  late String currentSelectedItem;

  @override
  void initState() {
    super.initState();
    currentSelectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDropdownMenu(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(currentSelectedItem), Icon(Icons.arrow_drop_down)],
        ),
      ),
    );
  }

  void _showDropdownMenu(BuildContext context) async {
    final selectedItem = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return _buildDropdownMenu();
      },
    );

    if (selectedItem != null) {
      setState(() {
        currentSelectedItem = selectedItem;
        widget.onChanged(selectedItem);
      });
    }
  }

  Widget _buildDropdownMenu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.items.map((item) {
          return ListTile(
            title: Text(item),
            onTap: () {
              Navigator.pop(context, item);
            },
          );
        }).toList(),
      ),
    );
  }
}
