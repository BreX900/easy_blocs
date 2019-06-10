import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


class EmailChecker extends Checker<String, EmailAuthError> {
  EmailChecker({@required Hand hand}) : super(hand: hand);

  @override
  EmailAuthError validate(String value) {
    if (value == null || value.isEmpty)
      return EmailAuthError.EMPTY;
    else if (!(value.contains('@') && value.split('@')[1].contains('.')))
      return EmailAuthError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [
    WhitelistingTextInputFormatter(RegExp('[a-zA-Z0-9@.]')),
  ];

  @override
  String get value => data.text;
}


enum EmailAuthError {/// Delete error in stream [null]
  /// Empty value
  EMPTY,
  /// The email address is badly formatted.
  INVALID, /// [ERROR_INVALID_EMAIL]
  /// There is no user record corresponding to this identifier. The user may have been deleted.
  USER_NOT_FOUND, /// [ERROR_USER_NOT_FOUND]
  /// The user account has been disabled by an administrator.
  USER_DISABLE, /// [ERROR_USER_DISABLED]
  /// Current email already use
  ALREADY_IN_USE, /// [ERROR_EMAIL_ALREADY_IN_USE]
}
