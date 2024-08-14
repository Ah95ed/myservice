import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/Models/constant/Constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatefulWidget {
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
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: getWidth(2)),
      child: TextFormField(
        obscureText:
            widget.input == TextInputType.visiblePassword ?
             isPassword : false,
        controller: widget.text,
        keyboardType: widget.input,
        decoration: InputDecoration(
          labelText: widget.hint,
          prefixIcon: Icon(
            widget.icons,
            color: ColorUsed.second,
          ),
          suffixIcon: widget.input == TextInputType.visiblePassword
              ? IconButton(
                  onPressed: () {
                    isPassword = !isPassword;
                    setState(() {});
                  },
                  icon: Icon(
                    isPassword
                     ? Icons.remove_red_eye
                      : Icons.visibility_off,
                    color: ColorUsed.second,
                  ),
                )
              : null,
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
