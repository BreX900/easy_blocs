import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSheet.dart';
import 'package:flutter/widgets.dart';


abstract class RepeatPasswordFieldBone extends PasswordFieldBone {}


class RepeatPasswordFieldSkeleton
    extends PasswordFieldSkeleton
    implements RepeatPasswordFieldBone {

  RepeatPasswordFieldSkeleton({
    TextFieldSheet initialValue: const TextFieldSheet(),
    List<FormFieldValidator<String>> validators,
  }) : super(
    initialValue: initialValue,
    validators: validators??RepeatPasswordFieldValidator.base,
  );
}

class RepeatPasswordFieldShell<B extends RepeatPasswordFieldBone> extends PasswordFieldShell<B> {
}



class RepeatPasswordFieldValidator {
  /// Add method password to PasswordField and method repeatPassword to RepeatPasswordField
  static List<FormFieldValidator<String>> get base {
    return PasswordFieldValidator.base;
  }

  String _password;

  String password(String value) {
    _password = value;
    return null;
  }

  String repeatPassword(String value) {
    if (_password != value)
      return "La password non corrisponde";
    return null;
  }
}