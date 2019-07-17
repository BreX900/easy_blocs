import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TextFieldSheet extends FieldSheet<String> {
  final TextInputType keyboardType;

  final bool obscureText;
  final int maxLength;

  final List<TextInputFormatter> inputFormatters;

  const TextFieldSheet({
    String value,
    this.keyboardType,
    this.obscureText: false, this.maxLength,
    this.inputFormatters,
  }) : super(
    value: value,
  );

  TextFieldSheet copyWith({
    Object value,
    TextInputType keyboardType,
    bool obscureText, int maxLength,
    List<TextInputFormatter> inputFormatters,
  }) {
    return TextFieldSheet(
      value: value??this.value,
      keyboardType: keyboardType??this.keyboardType,
      obscureText: obscureText??this.obscureText,
      maxLength: maxLength??this.maxLength,
      inputFormatters: inputFormatters??this.inputFormatters,
    );
  }
}