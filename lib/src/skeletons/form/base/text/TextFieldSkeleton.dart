//import 'package:easy_blocs/src/skeletons/form/base/text/TextFieldBone.dart';
//import 'package:easy_blocs/src/skeletons/form/base/text/TextFieldSheet.dart';
//import 'package:easy_blocs/src/skeletons/form/base/text/TextFieldValidator.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldSkeleton.dart';
//
//
//class TextFieldSkeleton extends FieldSkeleton<String, TextFieldSheet> implements TextFieldBone {
//  TextFieldSkeleton({
//    TextFieldSheet initialValue: const TextFieldSheet(),
//    List<FieldValidator<String>> validators: TextFieldValidator.base,
//  }): super(
//    initialValue: initialValue,
//    validators: validators,
//  );
//
//  String get text => sheet.value;
//  set text(String text) => sheet = sheet.copyWith(value: text);
//
//  @override
//  void onSaved(String value) {
//    controller.add(sheet.copyWith(
//      value: value,
//    ));
//  }
//
//  void inObscureText(bool isObscuredText) {
//    controller.add(sheet.copyWith(
//      obscureText: isObscuredText,
//    ));
//  }
//}