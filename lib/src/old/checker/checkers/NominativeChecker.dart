import 'package:easy_blocs/src/old/checker/checkers/StringChecker.dart';
import 'package:easy_blocs/src/old/checker/controllers/FocusHandler.dart';
import 'package:meta/meta.dart';


class NominativeChecker extends StringChecker {
  NominativeChecker({@required Hand hand}) : super(hand: hand);

  @override
  void onSaved(String value) {
    super.onSaved(value.trim());
  }

  @override
  Object validate(String str) {
    str = str.trim();
    final error = super.validate(str);
    if (error != null)
      return error;
    if(str.split(' ').length <= 1)
      return NominativeAuthError.INVALID;
    return null;
  }
}


enum NominativeAuthError {/// Delete error in stream [null]
  /// Badly formatted.
  INVALID,
}