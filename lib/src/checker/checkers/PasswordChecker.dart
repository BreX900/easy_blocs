import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class PasswordChecker extends StringChecker {
  PasswordChecker({@required Hand hand}) : super(hand: hand);

  @override
  Object validate(String str) {
    final error = super.validate(str);
    if (error != null)
      return error;
    if (str.length < 8) // TODO: Vedi [PasswordAuthError.INVALID] per completare questo controllo
      return PasswordAuthError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    BlacklistingTextInputFormatter(RegExp('[ ]'))
  ];
}


enum PasswordAuthError {/// Delete error in stream [null]
  /// Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter
  INVALID,
  /// Wrong password
  WRONG,
  /// It is not the same as the previous password
  NOT_SAME,
}

