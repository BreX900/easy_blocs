import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class EmailChecker extends StringChecker {
  EmailChecker({@required Hand hand}) : super(hand: hand);

  @override
  Object validate(String str) {
    final error = super.validate(str);
    if (error != null)
      return error;
    if (!(str.contains('@') && str.split('@')[1].contains('.')))
      return EmailSignError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9@.]')),
  ];
}

