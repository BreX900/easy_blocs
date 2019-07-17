import 'package:easy_blocs/src/skeletons/form/text/TextFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSheet.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldShell.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldValidator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class PasswordFieldBone extends TextFieldBone {}


class PasswordFieldSkeleton extends TextFieldSkeleton implements PasswordFieldBone {

  PasswordFieldSkeleton({
    TextFieldSheet initialValue: const TextFieldSheet(),
    List<FormFieldValidator<String>> validators,
  }) : super(
    initialValue: initialValue,
    validators: validators??PasswordFieldValidator.base,
  );
}


class PasswordFieldShell<B extends PasswordFieldBone> extends StatelessWidget {
  final TwoBuilder<TextFieldSheet, PasswordFieldBone, InputDecoration> dimmer;
  final TwoBuilder<TextFieldSheet, PasswordFieldBone, InputDecoration> clearer;

  const PasswordFieldShell({Key key,
    this.dimmer: _dimmer, this.clearer: _clearer,
  }) : super(key: key);

  static InputDecoration _dimmer(TextFieldSheet sheet, PasswordFieldBone bone) {
    return InputDecoration(
      prefix: IconButton(
        onPressed: () => bone.inObscureText(false),
        icon: const Icon(Icons.lock_outline),
      ),
    );
  }

  static InputDecoration _clearer(TextFieldSheet sheet, PasswordFieldBone bone) {
    return InputDecoration(
      prefix: IconButton(
        onPressed: () => bone.inObscureText(true),
        icon: const Icon(Icons.lock_outline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return TextFieldShell<B>(
      decorator: (sheet, bone) {
        return sheet.obscureText ? dimmer(sheet, bone) : clearer(sheet, bone);
      },
    );
  }
}


abstract class PasswordFieldValidator {
  static List<FormFieldValidator<String>> get base => [
    TextFieldValidator.notEmpty,
    password,
  ];

  static String password(String value) {
    if (value.length < 8)
      return "Campo troppo corto";
    return null;
  }
}


