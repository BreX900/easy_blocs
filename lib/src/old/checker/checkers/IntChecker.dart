import 'package:easy_blocs/src/old/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/old/checker/controllers/FocusHandler.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class IntChecker extends Checker<int, String> {
  IntChecker({
    @required Hand hand,
  }) : super(hand: hand);

  @override
  Object validate(String str) {
    if (str == null || str.isEmpty)
      return IntFieldErrors.EMPTY;
    else if(int.tryParse(str) == null)
      return IntFieldErrors.INVALID;
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

  @override
  final TextInputType keyboardType = TextInputType.number;
}


enum IntFieldErrors {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Badly formatted.
  INVALID,
}