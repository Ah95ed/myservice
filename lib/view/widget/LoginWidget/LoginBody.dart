import 'package:Al_Zab_township_guide/view/widget/constant/Constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
  TextFieldCustom({
    super.key,
    this.hint,
    this.icons,
    this.input,
    this.text,
  });
  String? hint;
  IconData? icons;
  TextInputType? input;
  TextEditingController? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: text,
        keyboardType: input,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(
            icons,
            color: ColorUsed.second,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorUsed.primary,
            ),
          ),
          labelStyle: TextStyle(
            color: ColorUsed.second,
          ),
        ),
      ),
    );
  }
}
