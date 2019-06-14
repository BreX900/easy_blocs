import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/checkers/AddressChecker.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/widget/StringField.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/Translator.dart';
import 'package:easy_blocs/src/translator/Widgets.dart';
import 'package:flutter/material.dart';


class AddressField extends StringField {

  AddressField({Key key,
    @required CheckerRule<String, String> checker, @required Hand hand,
    Translator translator: translatorAddressField,
    InputDecoration decoration: ADDRESS_DECORATION,
  }) : assert(checker != null), super(key: key,
    checker: checker, hand: hand, translator: translator,
    decoration: decoration,
  );

}

const ADDRESS_DECORATION = const TranslationsInputDecoration(

);


Translations translatorAddressField(Object error) {
  switch (error) {
    case AddressAuthError.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default:
      return translatorStringField(error);
  }
}

