import 'package:flutter/widgets.dart';


abstract class TextFieldValidator {
  static const List<FormFieldValidator<String>> base = const [
    notEmpty,
  ];

  static String notEmpty(String value) {
    if (value == null || value.isEmpty)
      return "Campo Vuoto";
    return null;
  }
}