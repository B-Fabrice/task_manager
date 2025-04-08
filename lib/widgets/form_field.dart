import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText, readOnly;
  final Widget? suffix;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  const AppFormField({
    required this.controller,
    required this.label,
    super.key,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.suffix,
    this.validator,
    this.onChange,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      controller: controller,
      validator: validator,
      onChanged: onChange,
      textInputAction: textInputAction,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(labelText: label, suffix: suffix),
    );
  }
}
