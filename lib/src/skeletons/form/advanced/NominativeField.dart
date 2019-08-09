import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:flutter/material.dart';


abstract class NominativeFieldBone extends TextFieldBone {}


class NominativeFieldSkeleton extends TextFieldSkeleton implements NominativeFieldBone {

  NominativeFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    value: value,
    validators: validators??NominativeFieldValidator.base,
  );
}


class NominativeFieldShell extends TextFieldShell {
  const NominativeFieldShell({Key key,
    NominativeFieldBone fieldBone,
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
        prefix: const Icon(Icons.account_circle),
      );
}

abstract class NominativeFieldValidator {
  static List<FieldValidator<String>> get base => [
    TextFieldValidator.undefined,
    nominative,
  ];

  static FieldError nominative(String value) {
    if (value.length < 8)
      return NominativeFieldError.short;
    if (value.split(" ").length < 2)
      return NominativeFieldError.nameAndSurname;
    return null;
  }
}

class NominativeFieldError {
  static const short = FieldError("SHORT");
  static const nameAndSurname = FieldError("NAME_AND_SURNAME");
}