import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class PhoneNumberChecker extends Checker<int, PhoneNumAuthError> {
  PhoneNumberChecker({
    @required Hand hand,
  }) : super(hand: hand);

  @override
  PhoneNumAuthError validate(String str) {
    if (str == null || str.isEmpty)
      return PhoneNumAuthError.EMPTY;
    else if(str.length != 10 || int.tryParse(str) == null)
      return PhoneNumAuthError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    WhitelistingTextInputFormatter(RegExp('[0-9]')),
  ];

  @override
  final int maxLength = 10;
  //@override
  //final int minLength = 10;

  @override
  int get value => int.tryParse(data.text);
}


enum PhoneNumAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Badly formatted.
  INVALID,
}