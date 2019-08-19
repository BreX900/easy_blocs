import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/EmailChecker.dart';
import 'package:flutter/material.dart';


class EmailField extends StringField {

  EmailField({Key key,
    @required CheckerRule<String, String> checker,
    Translator translator: translatorEmailField,
    InputDecoration decoration: const TranslationsInputDecoration(
      prefixIcon: const Icon(Icons.email),
      translationsHintText: const TranslationsConst(
        it: "Indirizzo Email",
        en: "Email Address",
      ),
    ),
  }) : assert(checker != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,
  );

}


Translations translatorEmailField(Object error) {
  switch (error) {
    case EmailSignError.INVALID: {
      return const TranslationsConst(
        it: "L'indirizzo email non è in un formato consono.",
        en: "The email address is badly formatted."
      );
    }
    case EmailSignError.USER_NOT_FOUND: {
      return const TranslationsConst(
        it: "Non esiste alcun utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.",
        en: "There is no user corresponding to this identifier. The user may have been deleted.",
      );
    }
    case EmailSignError.USER_DISABLE: {
      return const TranslationsConst(
        it: "The user account has been disabled by an administrator.",
        en: "L'account utente è stato disabilitato da un amministratore.",
      );
    }
    default:
      return translatorStringField(error);
  }
}
