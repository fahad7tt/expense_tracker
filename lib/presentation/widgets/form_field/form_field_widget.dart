import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle? labelStyle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final Color? cursorColor;
  final List<TextInputFormatter>? inputFormatters;

  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.labelStyle,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.cursorColor,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      cursorColor: cursorColor,
      inputFormatters: inputFormatters,
    );
  }
}
