import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.onChange,
      this.keyboardType = TextInputType.name,
      this.focus,
      this.hintText,
      this.inputFormatters,
      this.suffixIcon,
      this.obscureText = false});

  final String? hintText;
  final TextEditingController controller;
  final Function(String)? onChange;
  final TextInputType keyboardType;
  final FocusNode? focus;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: kIsWeb ? 16 : 8),
      child: TextFormField(
        obscureText: obscureText,
        focusNode: focus,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText ?? "Enter Here",
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xFF4B4E52)
                  : Color(0xFFFFFFFF).withOpacity(0.72),
              height: 1.4),
          border: InputBorder.none,
        ),
        onChanged: onChange,
        style:
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
        controller: controller,
      ),
    );
  }
}
