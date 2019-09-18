import 'package:flutter/services.dart';

class TextInputFormatters {
  static final List<TextInputFormatter> password = [BlacklistingTextInputFormatter(RegExp('[ ]'))];
  static final List<TextInputFormatter> email = [
    WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9@.]')),
  ];
  static final List<TextInputFormatter> integer = [
    WhitelistingTextInputFormatter(RegExp('[0-9]')),
  ];
  static final List<TextInputFormatter> phoneNumber = integer;
  static final List<TextInputFormatter> price = [WhitelistingTextInputFormatter(RegExp('[0-9.,]'))];
}
