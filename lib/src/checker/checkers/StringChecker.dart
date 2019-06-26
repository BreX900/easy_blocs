import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';


class StringChecker extends Checker<String, String> {
  final int maxWords;
  final int minWords;

  StringChecker({
    @required Hand hand,
    DataField<String> data,
    this.maxWords, this.minWords,
  }) : super(hand: hand, update: data);

  @override
  Object validate(String str) {
    if (str == null || str.isEmpty)
      return StringAuthError.EMPTY;
    else if((maxWords != null && str.split(' ').length < maxWords)
        || (minWords != null && str.split(' ').length >= minWords))
      return StringAuthError.INVALID;
    return null;
  }

  @override
  void onSaved(String value) {
    add(data.copyWith(value: value));
  }
}


enum StringAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// Badly formatted.
  INVALID,
}