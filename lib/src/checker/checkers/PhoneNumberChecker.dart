import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/IntChecker.dart';
import 'package:meta/meta.dart';


class PhoneNumberChecker extends IntChecker {
  PhoneNumberChecker({
    @required Hand hand,
  }) : super(hand: hand);

  @override
  Object validate(String str) {
    if (super.validate(str) == null && str.length != 10)
      return PhoneNumberFieldError.INVALID;
    return null;
  }

  @override
  final int maxLength = 10;
}


enum PhoneNumberFieldError {/// Delete error in stream [null]
  /// Badly formatted.
  INVALID,
}