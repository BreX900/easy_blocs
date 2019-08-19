import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:flutter/material.dart';


abstract class NominativeFieldBone extends TextFieldBone {}


class NominativeFieldSkeleton extends TextFieldSkeleton implements NominativeFieldBone {

  NominativeFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }) : super(
    seed: value,
    validators: validators??NominativeFieldValidator.base,
  );

  @override
  void inValue(String value) {
    super.inValue(value?.trim());
  }
}


class NominativeFieldShell extends TextFieldShell {

  NominativeFieldShell({Key key,
    @required NominativeFieldBone bone,
    FocuserBone mapFocusBone, FocusNode focusNode,
    InputDecoration decoration,
  }) : super(key: key,
    bone: bone,
    mapFocusBone: mapFocusBone,
    focusNode: focusNode,
    decoration: decoration??decorator(bone),
  );

  static InputDecoration decorator(NominativeFieldBone fieldBone, {
    TranslationsInputDecoration decoration: const TranslationsInputDecoration(),
  }) {

    return decoration.copyWithTranslations(
      prefixIcon: Icon(Icons.account_circle),
      translationsHintText: TranslationsConst(
        it: "Nome e Cognome",
        en: "Name and Surname",
      ),
    );
  }
}

abstract class NominativeFieldValidator {
  static List<FieldValidator<String>> get base => [
    TextFieldValidator.undefined,
    nominative,
  ];

  static Future<FieldError> nominative(String value) async {
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