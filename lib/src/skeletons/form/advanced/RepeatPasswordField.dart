import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';


abstract class RepeatPasswordFieldBone extends PasswordFieldBone {}


class RepeatPasswordFieldSkeleton
    extends PasswordFieldSkeleton
    implements RepeatPasswordFieldBone {

  RepeatPasswordFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    value: value,
    validators: validators??RepeatPasswordFieldValidator.base,
  );
}

class RepeatPasswordFieldShell extends PasswordFieldShell {}



class RepeatPasswordFieldValidator {
  /// Add method password to PasswordField and method repeatPassword to RepeatPasswordField
  static List<FieldValidator<String>> get base => PasswordFieldValidator.base;

  String _password;

  FieldError password(String value) {
    _password = value;
    return null;
  }

  FieldError repeatPassword(String value) {
    if (_password != value)
      return RepeatPasswordFieldError.notSame;
    return null;
  }
}

class RepeatPasswordFieldError {
  static const notSame = FieldError("NOT_SAME");
}