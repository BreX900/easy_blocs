import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class AddressChecker extends Checker<String, AddressAuthError> {
  AddressChecker({@required Hand hand}) : super(hand: hand);

  @override
  AddressAuthError validate(String str) {
    if (str == null || str.isEmpty)
      return AddressAuthError.EMPTY;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = null;

  @override
  String get value => data.text;
}


enum AddressAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// The address is badly formatted.
  INVALID,
}
