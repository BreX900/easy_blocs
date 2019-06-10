import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class NominativeChecker extends Checker<String, NominativeAuthError> {
  NominativeChecker({@required Hand hand}) : super(hand: hand);

  @override
  NominativeAuthError validate(String str) {
    if (str == null || str.isEmpty)
      return NominativeAuthError.EMPTY;
    else if(str.split(' ').length != 2)
      return NominativeAuthError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    WhitelistingTextInputFormatter(RegExp('[a-zA-Z ]')),
  ];

  @override
  String get value => data.text;
}


enum NominativeAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Badly formatted.
  INVALID,
}