import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:meta/meta.dart';


class AddressChecker extends StringChecker {
  AddressChecker({@required Hand hand}) : super(hand: hand);

  @override
  Object validate(String str) {
    final error = super.validate(str);
    if (error != null)
      return error;
    return null;
  }

}


enum AddressAuthError {/// Delete error in stream [null]
  /// The address is badly formatted.
  INVALID,
}
