import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/NominativeChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/material.dart';


class NominativeField extends CheckerField<String, NominativeAuthError> {

  NominativeField({Key key,
    @required Checker<String, NominativeAuthError> checker,
    Translator<NominativeAuthError> translator: translatorNominativeField,
    InputDecoration decoration: const InputDecoration(),
    bool defaultDecoration: true,
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: mergeInputDecoration(decoration, nominativeDecoration, defaultDecoration,
      hintText: nominativeHintText
    ),
  );

}


const nominativeDecoration = const InputDecoration(
  prefixIcon: const Icon(Icons.account_circle),
);


final nominativeHintText = Translations(
    it: "Nome e Cognome",
    en: "Name and Surname"
);


Translations translatorNominativeField(NominativeAuthError error) {
  switch (error) {
    case NominativeAuthError.EMPTY: {
      return Translations(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case NominativeAuthError.INVALID: {
      return Translations(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}