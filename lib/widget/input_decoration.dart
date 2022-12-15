import 'package:flutter/material.dart';

InputDecoration inputDecorationForm(Widget label,
    {Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      label: label);
}
