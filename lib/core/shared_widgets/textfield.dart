import 'package:flutter/material.dart';

import '../constants/styles_constants.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final double? borderRadius;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final String? labelText;
  final bool? readOnly;

  const AppTextField(
      {super.key,
      this.hintText,
      this.prefixIcon,
      this.borderColor,
      this.borderRadius,
      this.controller,
      this.keyboardType,
      this.onChanged,
      this.onTap,
      this.initialValue,
      this.textInputAction,
      this.decoration,
      this.suffixIcon,
      this.labelText,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      textInputAction: textInputAction,
      initialValue: initialValue,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10.0))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 10.0)),
          borderSide: BorderSide(color: borderColor ?? Colors.transparent, width: 1.0),
        ),
        // filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: Pallete.lightGrey100,
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
