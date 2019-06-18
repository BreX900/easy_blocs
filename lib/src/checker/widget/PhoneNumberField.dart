import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/PhoneNumberChecker.dart';
import 'package:easy_blocs/src/checker/widget/IntField.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/Translator.dart';
import 'package:easy_blocs/src/translator/Widgets.dart';
import 'package:flutter/material.dart';


class PhoneNumberField extends IntField {

  PhoneNumberField({Key key,
    @required CheckerRule<int, String> checker,
    Translator translator: translatorPhoneNumberField,
    InputDecoration decoration: PHONE_NUMBER_DECORATION,
    bool defaultDecoration,
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,
  );

}


const PHONE_NUMBER_DECORATION = const TranslationsInputDecoration(
  prefixIcon: const Icon(Icons.phone),
  translationsHintText: const TranslationsConst(
      it: "Numero di Telefono",
      en: "Phone Number"
  ),
);


Translations translatorPhoneNumberField(Object error) {
  switch (error) {
    case PhoneNumberFieldError.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default:
      return translatorIntField(error);
  }
}