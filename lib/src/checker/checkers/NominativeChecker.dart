import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:meta/meta.dart';


class NominativeChecker extends StringChecker {
  NominativeChecker({@required Hand hand}) : super(hand: hand);

  @override
  Object validate(String str) {
    final error = super.validate(str);
    if (error != null)
      return error;
    if(str.split(' ').length != 2)
      return NominativeAuthError.INVALID;
    return null;
  }
}


enum NominativeAuthError {/// Delete error in stream [null]
  /// Badly formatted.
  INVALID,
}