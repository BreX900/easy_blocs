import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/EmailChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:flutter/material.dart';


class EmailField extends CheckerField<String, EmailAuthError> {

  const EmailField({Key key,
    @required Checker<String, EmailAuthError> checker,
    Translator<EmailAuthError> translator: translatorEmailField,
    InputDecoration decoration: const InputDecoration(),
  }) : assert(checker != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,
  );

}


Translations translatorEmailField(EmailAuthError error) {
  switch (error) {
    case EmailAuthError.INVALID: {
      return Translations(
        it: "L'indirizzo email non è in un formato consono.",
        en: "The email address is badly formatted."
      );
    }
    case EmailAuthError.EMPTY: {
      return Translations(
        it: "Campo vuoto. Scrivi la tua email.",
        en: "Empty field. Write your email.",
      );
    }
    case EmailAuthError.USER_NOT_FOUND: {
      return Translations(
        it: "Non esiste alcun utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.",
        en: "There is no user corresponding to this identifier. The user may have been deleted.",
      );
    }
    case EmailAuthError.USER_DISABLE: {
      return Translations(
        it: "The user account has been disabled by an administrator.",
        en: "L'account utente è stato disabilitato da un amministratore.",
      );
    }
    default: return null;
  }
}
