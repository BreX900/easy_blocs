import 'package:easy_blocs/src/skeletons/form/text/TextFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldValidator.dart';
import 'package:flutter/widgets.dart';


abstract class IntFieldBone extends TextFieldBone {}


class IntFieldSkeleton extends TextFieldSkeleton implements IntFieldBone {
  int get integer => int.tryParse(text);
}


class IntFieldValidator {
  List<FormFieldValidator<String>> get base {
    final intValidator = IntFieldValidator();
    return [
      TextFieldValidator.notEmpty,
      intValidator.notInt,
    ];
  }

  final List<FormFieldValidator<int>> validators;

  const IntFieldValidator({this.validators: const []});

  String notInt(String value) {
    final integer = int.tryParse(value);
    if (integer == null)
      return "Deve essere un numero";
    for (var validator in validators) {
      final error = validator(integer);
      if (error != null)
        return error;
    }
    return null;
  }
}