import 'package:easy_blocs/src/skeletons/form/field/FieldSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSheet.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldValidator.dart';
import 'package:flutter/widgets.dart';


class TextFieldSkeleton extends FieldSkeleton<String, TextFieldSheet> implements TextFieldBone {
  TextFieldSkeleton({
    TextFieldSheet initialValue: const TextFieldSheet(),
    List<FormFieldValidator<String>> validators: TextFieldValidator.base,
  }): super(
    initialValue: initialValue,
    validators: validators,
  );

  String get text => sheet.value;

  @override
  void onSaved(String value) {
    controller.add(sheet.copyWith(
      value: value,
    ));
  }

  void inObscureText(bool isObscuredText) {
    controller.add(sheet.copyWith(
      obscureText: isObscuredText,
    ));
  }
}