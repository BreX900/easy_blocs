import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/IntChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:flutter/material.dart';


class IntField extends CheckerField<int> {
  IntField({Key key,
    @required CheckerRule<int, String> checker,
    Translator translator: translatorIntField,
    InputDecoration decoration: const InputDecoration(),
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,
  );
}


Translations translatorIntField(Object error) {
  switch (error) {
    case IntFieldErrors.EMPTY: {
      return const TranslationsConst(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case IntFieldErrors.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}