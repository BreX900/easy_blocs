import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:flutter/material.dart';


abstract class PasswordFieldBone extends TextFieldBone {}


class PasswordFieldSkeleton extends TextFieldSkeleton implements PasswordFieldBone {

  PasswordFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    value: value,
    validators: validators??PasswordFieldValidator.base,
  );
}


class PasswordFieldShell extends TextFieldShell {

  PasswordFieldShell({Key key,
    @required PasswordFieldBone fieldBone,
    MapFocusBone mapFocusBone, FocusNode focusNode,
    InputDecoration decoration,
  }) : super(key: key,
    bone: fieldBone,
    mapFocusBone: mapFocusBone, focusNode: focusNode,
    decoration: decoration??_decorator(fieldBone),
  );

  static InputDecoration _decorator(PasswordFieldBone fieldBone) {
    void setObscureText(bool isObscureText) {
      fieldBone.shield = fieldBone.shield.copyWith(obscureText: isObscureText);
    }

    return fieldBone.shield.obscureText ? InputDecoration(
      prefix: IconButton(
        onPressed: () => setObscureText(false),
        icon: const Icon(Icons.lock_outline),
      ),
    ) : InputDecoration(
      prefix: IconButton(
        onPressed: () => setObscureText(true),
        icon: const Icon(Icons.lock_outline),
      ),
    );
  }
}


abstract class PasswordFieldValidator {
  static List<FieldValidator<String>> get base => [
    TextFieldValidator.undefined,
    password,
  ];

  static FieldError password(String value) {
    if (value.length < 8)
      return PasswordFieldError.short;
    return null;
  }
}

class PasswordFieldError {
  static const undefined = FieldError.undefined;
  static const short = FieldError("SHORT");
}
