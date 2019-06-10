import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/PhoneNumberChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/material.dart';


class PhoneNumberField extends CheckerField<String, PhoneNumAuthError> {

  PhoneNumberField({Key key,
    @required Checker<String, PhoneNumAuthError> checker,
    Translator<PhoneNumAuthError> translator: translatorPhoneNumberField,
    InputDecoration decoration: const InputDecoration(),
    bool defaultDecoration,
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: mergeInputDecoration(decoration, phoneNumberDecoration, defaultDecoration,
        hintText: phoneNumberHintText,
    ),
  );

}


const phoneNumberDecoration = const InputDecoration(
  prefixIcon: const Icon(Icons.phone),
);


final phoneNumberHintText = Translations(
    it: "Numero di Telefono",
    en: "Phone Number"
);


Translations translatorPhoneNumberField(PhoneNumAuthError error) {
  switch (error) {
    case PhoneNumAuthError.EMPTY: {
      return Translations(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case PhoneNumAuthError.INVALID: {
      return Translations(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}