import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class PasswordChecker extends Checker<String, PasswordAuthError> {
  PasswordChecker({@required Hand hand}) : super(hand: hand);

  @override
  PasswordAuthError validate(String str) {
    if (str == null || str.isEmpty)
      return PasswordAuthError.EMPTY;
    else if (str.length < 8) // TODO: Vedi [PasswordAuthError.INVALID] per completare questo controllo
      return PasswordAuthError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    BlacklistingTextInputFormatter(RegExp('[ ]'))
  ];

  @override
  String get value => data.text;
}


enum PasswordAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter
  INVALID,
  /// Wrong password
  WRONG,
  /// It is not the same as the previous password
  NOT_SAME,
}

