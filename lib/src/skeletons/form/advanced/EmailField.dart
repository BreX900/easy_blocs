import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/skeletons/form/TextInputFormatters.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:flutter/material.dart';

abstract class EmailFieldBone extends TextFieldBone {}

class EmailFieldSkeleton extends TextFieldSkeleton implements EmailFieldBone {
  EmailFieldSkeleton({
    String value,
    TextFieldSheet sheet: const TextFieldSheet(),
    List<FieldValidator<String>> validators,
  }) : super(
          seed: value,
          sheet: sheet.copyWith(inputFormatters: TextInputFormatters.email),
          validators: validators ?? EmailFieldValidator.base,
        );

  void inSignError(EmailSignError error) {
    inError(_convertSignError(error));
  }

  FieldError _convertSignError(EmailSignError error) {
    switch (error) {
      case EmailSignError.INVALID:
        return EmailFieldError.invalid;
      case EmailSignError.USER_NOT_FOUND:
        return EmailFieldError.userNotFound;
      case EmailSignError.USER_DISABLE:
        return EmailFieldError.userDisable;
      case EmailSignError.ALREADY_IN_USE:
        return EmailFieldError.alreadyInUse;
      default:
        return null;
    }
  }
}

class EmailFieldShell extends TextFieldShell {
  EmailFieldShell({
    Key key,
    @required EmailFieldBone bone,
    FocuserBone mapFocusBone,
    FocusNode focusNode,
    FieldErrorTranslator nosy: noisy,
    InputDecoration decoration,
  }) : super(
          key: key,
          bone: bone,
          mapFocusBone: mapFocusBone,
          focusNode: focusNode,
          nosy: nosy,
          decoration: decoration ?? decorator(bone),
        );

  static InputDecoration decorator(EmailFieldBone fieldBone) => const TranslationsInputDecoration(
        prefixIcon: const Icon(Icons.email),
        translationsHintText: TranslationsConst(
          en: "E-mail",
        ),
      );
  static TranslationsConst noisy(FieldError error) {
    switch (error) {
      case EmailFieldError.userNotFound:
        return const TranslationsConst(
          it: "Non esiste alcun utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato.",
          en: "There is no user corresponding to this identifier. The user may have been deleted.",
        );
      case EmailFieldError.invalid:
        return const TranslationsConst(
            it: "L'indirizzo email non è in un formato consono.",
            en: "The email address is badly formatted.");
      case EmailFieldError.userDisable:
        return const TranslationsConst(
          it: "The user account has been disabled by an administrator.",
          en: "L'account utente è stato disabilitato da un amministratore.",
        );
      default:
        return basicNoisy(error);
    }
  }
}

abstract class EmailFieldValidator {
  static List<FieldValidator<String>> get base => [
        TextFieldValidator.undefined,
        email,
      ];

  static Future<FieldError> email(String value) async {
    if (value.length < 8) return EmailFieldError.short;
    return null;
  }
}

class EmailFieldError {
  static const FieldError short = FieldError("SHORT");
  static const FieldError invalid = FieldError.$invalid;
  static const FieldError userNotFound = FieldError("USER_NOT_FOUND");
  static const FieldError userDisable = FieldError("USER_DISABLE");
  static const FieldError wrong = FieldError("WRONG");
  static const FieldError alreadyInUse = FieldError("ALREADY_IN_USE");
}
