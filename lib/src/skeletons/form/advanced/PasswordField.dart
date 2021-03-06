import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/Focuser.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/skeletons/form/TextInputFormatters.dart';
import 'package:easy_blocs/src/skeletons/form/base/TextField.dart';
import 'package:easy_blocs/src/user/Sign.dart';
import 'package:flutter/material.dart';

abstract class PasswordFieldBone extends TextFieldBone {
  Future<void> inObscureText(bool obscureText);
}

class PasswordFieldSkeleton extends TextFieldSkeleton implements PasswordFieldBone {
  PasswordFieldSkeleton({
    String value,
    TextFieldSheet sheet: const TextFieldSheet(),
    List<FieldValidator<String>> validators,
  }) : super(
          seed: value,
          sheet: sheet.copyWith(inputFormatters: TextInputFormatters.password),
          validators: validators ?? PasswordFieldValidator.base,
        );

  Future<void> inObscureText(bool obscureText) => inSheet(sheet.copyWith(obscureText: obscureText));

  void inSignError(PasswordSignError error) {
    inError(_convertSignError(error));
  }

  FieldError _convertSignError(PasswordSignError error) {
    switch (error) {
      case PasswordSignError.INVALID:
        return PasswordFieldError.invalid;
      case PasswordSignError.WRONG:
        return PasswordFieldError.wrong;
      case PasswordSignError.NOT_SAME:
        return PasswordFieldError.notSame;
      default:
        return null;
    }
  }
}

class PasswordFieldShell extends ObservableBuilder<bool> {
  PasswordFieldShell({
    Key key,
    @required PasswordFieldBone bone,
    FocuserBone mapFocusBone,
    FocusNode focusNode,
    FieldErrorTranslator nosy: noisy,
    InputDecoration decoration: const InputDecoration(),
    TextInputAction textInputAction,
  }) : super(
          key: key,
          initialData: true,
          stream: bone.outSheet.map((sheet) => sheet.obscureText),
          builder: (context, isObscuredText, update) {
            return TextFieldShell(
              bone: bone,
              mapFocusBone: mapFocusBone,
              focusNode: focusNode,
              nosy: nosy,
              decoration: decorator(decoration, bone: bone, obscuredText: isObscuredText),
              textInputAction: textInputAction,
            );
          },
        );

  static InputDecoration decorator(
    InputDecoration decoration, {
    @required PasswordFieldBone bone,
    @required bool obscuredText,
  }) {
    return decoration.copyWith(
      prefixIcon: decoration.prefixIcon != null
          ? null
          : (obscuredText
              ? IconButton(
                  onPressed: () => bone.inObscureText(false),
                  icon: const Icon(Icons.lock),
                )
              : IconButton(
                  onPressed: () => bone.inObscureText(true),
                  icon: const Icon(Icons.lock_outline),
                )),
      hintText: decoration.hintText != null
          ? null
          : const TranslationsConst(
              en: "Password",
            ).text,
    );
  }

  static TranslationsConst noisy(FieldError error) {
    switch (error) {
      case PasswordFieldError.short:
        return const TranslationsConst(
          it: "Deve avere almeno 8 caratteri",
          en: "Must have at least 8 characters",
        );
      case PasswordFieldError.invalid:
        return const TranslationsConst(
            it: "Deve avere almeno 8 caratteri, un numero, un simbolo, una lettera minuscola e una maiuscola.",
            en: "Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter.");
      case PasswordFieldError.wrong:
        return const TranslationsConst(
          it: "La password non è corretta o l'utente non ha una password.",
          en: "The password is invalid or the user does not have a password.",
        );
      case PasswordFieldError.notSame:
        return const TranslationsConst(
          it: "La password non è uguale alla precedente.",
          en: "The password is not the same as the previous one.",
        );
      default:
        return basicNoisy(error);
    }
  }
}

abstract class PasswordFieldValidator {
  static List<FieldValidator<String>> get base => [
        TextFieldValidator.undefined,
        password,
      ];

  static Future<FieldError> password(String value) async {
    if (value.length < 8) return PasswordFieldError.short;
    return null;
  }
}

class PasswordFieldError {
  static const FieldError undefined = FieldError.$undefined;
  static const FieldError short = FieldError("SHORT");
  static const FieldError invalid = FieldError.$invalid;
  static const FieldError wrong = FieldError("WRONG");
  static const FieldError notSame = FieldError("NOT_SMAE");
}
