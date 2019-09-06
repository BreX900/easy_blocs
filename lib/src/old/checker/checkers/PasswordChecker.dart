import 'package:easy_blocs/src/old/checker/checkers/StringChecker.dart';
import 'package:easy_blocs/src/old/checker/controllers/FocusHandler.dart';
import 'package:easy_blocs/src/user/Sign.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class PasswordChecker extends StringChecker {
  PasswordChecker({@required Hand hand}) : super(hand: hand);

  @override
  Object validate(String str) {
    final error = super.validate(str);
    if (error != null) return error;
    if (str.length < 8) // TODO: Vedi [PasswordAuthError.INVALID] per completare questo controllo
      return PasswordSignError.INVALID;
    return null;
  }

  @override
  final List<TextInputFormatter> inputFormatters = [BlacklistingTextInputFormatter(RegExp('[ ]'))];
}
