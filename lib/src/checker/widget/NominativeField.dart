import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/NominativeChecker.dart';
import 'package:flutter/material.dart';


class NominativeField extends StringField {

  NominativeField({Key key,
    @required CheckerRule<String, String> checker, @required Hand hand,
    Translator translator: translatorNominativeField,
    InputDecoration decoration: NOMINATIVE_DECORATION,
    bool defaultDecoration: true,
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, hand: hand, translator: translator,
    decoration: decoration,
  );

}


const NOMINATIVE_DECORATION = const TranslationsInputDecoration(
  prefixIcon: const Icon(Icons.account_circle),
  translationsHintText: const TranslationsConst(
      it: "Nome e Cognome",
      en: "Name and Surname"
  ),
);


Translations translatorNominativeField(Object error) {
  switch (error) {
    case NominativeAuthError.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default:
      return translatorStringField(error);
  }
}