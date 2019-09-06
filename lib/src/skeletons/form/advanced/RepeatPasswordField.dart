import 'package:easy_blocs/src/skeletons/Focuser.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/Widgets.dart';
import 'package:flutter/material.dart';


abstract class RepeatPasswordFieldBone extends PasswordFieldBone {}


class RepeatPasswordFieldSkeleton extends PasswordFieldSkeleton
    implements RepeatPasswordFieldBone {

  RepeatPasswordFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    value: value,
    validators: validators??RepeatPasswordFieldValidator.base,
  );
}

class RepeatPasswordFieldShell extends PasswordFieldShell {
  RepeatPasswordFieldShell({Key key,
    @required RepeatPasswordFieldBone bone,
    FocuserBone mapFocusBone, FocusNode focusNode,
    InputDecoration decoration,
    TextInputAction textInputAction,
  }) : super(key: key,
    bone: bone,
    mapFocusBone: mapFocusBone, focusNode: focusNode,
    decoration: decoration??decorator(bone),
      textInputAction: textInputAction,
  );

  static InputDecoration decorator(PasswordFieldBone bone, {
    TranslationsInputDecoration decoration: const TranslationsInputDecoration(),
    bool prefixIcon: true, hintText: true,
  }) {

    return PasswordFieldShell.decorator(bone, decoration: decoration.copyWithTranslations(
      translationsHintText: hintText ? TranslationsConst(
        en: "Repeat Password",
        it: "Ripeti la Password",
      ) : null,
    ), hintText: false);
  }
}



class RepeatPasswordFieldValidator {
  /// Add method password to PasswordField and method repeatPassword to RepeatPasswordField
  static List<FieldValidator<String>> get base => PasswordFieldValidator.base;

  String _password;

  Future<FieldError> password(String value) async {
    _password = value;
    return null;
  }

  Future<FieldError> repeatPassword(String value) async {
    if (_password != value)
      return RepeatPasswordFieldError.notSame;
    return null;
  }
}

class RepeatPasswordFieldError {
  static const notSame = FieldError("NOT_SAME");
}