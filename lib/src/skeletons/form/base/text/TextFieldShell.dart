//import 'dart:async';
//
//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
//import 'package:easy_blocs/src/skeletons/form/base/text/TextFieldBone.dart';
//import 'package:easy_blocs/src/skeletons/form/base/text/TextFieldSheet.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:flutter/material.dart';
//
//
//class TextFieldShell<B extends TextFieldBone> extends StatefulWidget
//    implements FieldShell<B>, FocusShell {
//  @override
//  final B fieldBone;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  @override
//  final FieldErrorTranslator nosy;
//  final FieldDecorator<B> decorator;
//
//  const TextFieldShell({Key key,
//    this.fieldBone,
//    this.mapFocusBone, this.focusNode,
//    this.nosy, this.decorator,
//  }) : super(key: key);
//
//  @override
//  TextFieldShellState<B> createState() => TextFieldShellState<B>();
//}
//
//class TextFieldShellState<B extends TextFieldBone> extends State<TextFieldShell<B>>
//    with FocusShellStateMixin, FieldShellStateMixin<B, TextFieldShell<B>> {
//
//  @override
//  Widget build(BuildContext context) {
//
//    return ObservableBuilder((_, sheet, state) {
//
//      return TextFormField(
//        initialValue: sheet.value == null ? sheet.value : sheet.value.toString(),
//
//        focusNode: focusNode,
//
//        decoration: widget.decorator(fieldBone),
//
//        keyboardType: sheet.keyboardType,
//
//        obscureText: sheet.obscureText,
//        maxLength: sheet.maxLength,
//
//        onFieldSubmitted: (_) => nextFocus(),
//
//        onSaved: fieldBone.onSaved,
//        validator: nosy<String>(),
//
//        inputFormatters: sheet.inputFormatters,
//      );
//    }, stream: fieldBone.outFieldSheet,);
//  }
//}



//class TextFieldShell<B extends TextFieldBone>
//    extends FocusFieldBuilder<String, TextFieldSheet, B> {
//
//  TextFieldShell({Key key,
//    FormBone formBone, B bone,
//    MapFocusBone automaticFocusBone, FocusNode focusNode,
//    FieldShellDecorator<B, TextFieldSheet> decorator: _decorator,
//  }) : super(key: key,
//    formBone: formBone, bone: bone,
//    automaticFocusBone: automaticFocusBone, focusNode: focusNode,
//    builder: (bone, sheet, focuser) => build(bone, sheet, focuser, focusNode, decorator),
//  );
//
//  static Widget build<B extends TextFieldBone>(
//      B bone, TextFieldSheet sheet,
//      MapFocusBone automaticFocusBone, FocusNode focusNode,
//      FieldShellDecorator<B, TextFieldSheet> decorator) {
//
//    return TextFormField(
//      initialValue: sheet.value == null ? sheet.value : sheet.value.toString(),
//
//      focusNode: focusNode,
//
//      decoration: decorator(bone, sheet),
//
//      keyboardType: sheet.keyboardType,
//
//      obscureText: sheet.obscureText,
//      maxLength: sheet.maxLength,
//
//      onFieldSubmitted: automaticFocusBone == null ? null
//          : (_) => automaticFocusBone.nextFocus(focusNode),
//      onSaved: bone.onSaved,
//      validator: bone.validator,
//
//      inputFormatters: sheet.inputFormatters,
//    );
//  }
//
//  static InputDecoration _decorator(_, __) => null;
//}
//
//class _TextFieldShellState extends State<TextFieldShell> with FocusBuilderStateMixin {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
