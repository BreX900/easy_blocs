import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/AddressChecker.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/material.dart';


class AddressField extends CheckerField<String, AddressAuthError> {

  AddressField({Key key,
    @required Checker<String, AddressAuthError> checker,
    Translator<AddressAuthError> translator: translatorAddressField,
    InputDecoration decoration: const InputDecoration(),
    bool defaultDecoration,
  }) : assert(checker != null), super(key: key,
    checker: checker, translator: translator,
    decoration: mergeInputDecoration(decoration, addressDecoration, defaultDecoration,
      hintText: addressHintText,
    ),
  );

}

const addressDecoration = const InputDecoration(
  prefixIcon: const Icon(Icons.home),
);


final addressHintText = Translations(
    it: "Indirizzo",
    en: "Address"
);

Translations translatorAddressField(AddressAuthError error) {
  switch (error) {
    case AddressAuthError.EMPTY: {
      return Translations(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case AddressAuthError.INVALID: {
      return Translations(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}