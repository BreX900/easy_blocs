import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:flutter/material.dart';


abstract class EmailFieldBone extends TextFieldBone {}


class EmailFieldSkeleton extends TextFieldSkeleton implements EmailFieldBone {

  EmailFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    value: value,
    validators: validators??EmailFieldValidator.base,
  );
}


class EmailFieldShell extends TextFieldShell {
  const EmailFieldShell({Key key,
    EmailFieldBone fieldBone,
    MapFocusBone mapFocusBone, FocusNode focusNode,
    FieldDecorator<TextFieldShellState> decorator: basicDecorator,
  }) : super(
    key: key,
    bone: fieldBone,
    mapFocusBone: mapFocusBone,
    focusNode: focusNode,
  );

  static InputDecoration basicDecorator(_) =>
      const InputDecoration(
        prefix: const Icon(Icons.email),
      );
}

abstract class EmailFieldValidator {
  static List<FieldValidator<String>> get base => [
    TextFieldValidator.undefined,
    email,
  ];

  static FieldError email(String value) {
    if (value.length < 8)
      return EmailFieldError.short;
    return null;
  }
}

class EmailFieldError {
  static const short = FieldError("SHORT");
}