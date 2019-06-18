import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class IntChecker extends Checker<int, String> {
  IntChecker({
    @required Hand hand,
  }) : super(hand: hand);

  @override
  Object validate(String str) {
    if (str == null || str.isEmpty)
      return IntFieldError.EMPTY;
    else if(int.tryParse(str) == null)
      return IntFieldError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    WhitelistingTextInputFormatter(RegExp('[0-9]')),
  ];

  @override
  void onSaved(String str) {
    add(data.copyWith(value: int.tryParse(str)));
  }
}


enum IntFieldError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Badly formatted.
  INVALID,
}