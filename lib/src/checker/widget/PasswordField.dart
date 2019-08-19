import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/PasswordChecker.dart';
import 'package:flutter/material.dart';


class PasswordField extends StringField {
  PasswordField({
    @required CheckerRule<String, String> checker,
    InputDecoration decoration: const TranslationsInputDecoration(
      prefixIcon: const Icon(Icons.lock),
      translationsHintText: const TranslationsConst(
        it: "Password",
        en: "Password",
      ),
    ),
  }) : super(
      checker: checker, translator: translatorPasswordField,
    decoration: decoration.copyWith(
      prefixIcon: CacheStreamBuilder<DataField>(
        stream: checker.outData,
        builder: (_, snap) {
          final data = snap.data;
          return IconButton(
            onPressed: () => checker.obscureText(!data.obscureText),
            icon: data.obscureText ? const Icon(Icons.lock) : const Icon(Icons.lock_outline),
          );
        }
      ),
    )
  );
}


const PASSWORD_REPEAT_DECORATION = const TranslationsInputDecoration(
  prefixIcon: const Icon(Icons.lock),
  translationsHintText: const TranslationsConst(
    it: "Ripeti la Password",
    en: "Repeat Password",
  ),
);


Translations translatorPasswordField(Object error) {
  switch (error) {
    case PasswordSignError.INVALID: {
      return const TranslationsConst(
          it: "Deve avere almeno 8 caratteri, un numero, un simbolo, una lettera minuscola e una maiuscola.",
          en: "Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter."
      );
    }
    case PasswordSignError.WRONG: {
      return const TranslationsConst(
        it: "La password non è corretta o l'utente non ha una password.",
        en: "The password is invalid or the user does not have a password.",
      );
    }
    case PasswordSignError.NOT_SAME: {
      return const TranslationsConst(
        it: "La password non è uguale alla precedente.",
        en: "The password is not the same as the previous one.",
      );
    }
    default:
      return translatorStringField(error);
  }
}


/*class PasswordField extends StatefulWidget {
  final PasswordChecker checker;
  final Translator<PasswordAuthError> translator;
  final InputDecoration decoration;
  final bool obscureText;

  const PasswordField({Key key,
    @required this.checker, this.translator: translatorPasswordField,
    this.decoration: const InputDecoration(), this.obscureText: true,
  }) : assert(checker != null), super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: widget.checker.outValue,
      builder: (context, snap) {

        return TextFormField(
          focusNode: widget.checker.focusNode,
          inputFormatters: widget.checker.inputFormatters,
          validator: (value) => widget.translator(widget.checker.validate(value))?.text,
          onSaved: widget.checker.onSaved,
          onFieldSubmitted: (_) => widget.checker.nextFinger(context),
          obscureText: _obscureText,
          decoration: widget.decoration.copyWith(
            labelText: snap.data,
            errorText: snap.error is PasswordAuthError ? '${snap.error}' : null,
            prefixIcon:
          ),
        );
      },
    );
  }
}*/