import 'dart:async';

import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/form/FormSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSheet.dart';
import 'package:flutter/material.dart';


typedef V TwoBuilder<O, T, V>(O one, T two);


class TextFieldShell<B extends TextFieldBone> extends StatefulWidget {
  final FormSkeleton skeleton;
  final B bone;

  final TwoBuilder<TextFieldSheet, B, InputDecoration> decorator;

  const TextFieldShell({Key key,
    this.skeleton, this.bone,
    this.decorator: _decorator,
  }) : super(key: key);

  static InputDecoration _decorator(TextFieldSheet sheet, TextFieldBone bone) => null;

  @override
  _TextFieldShellState<B> createState() => _TextFieldShellState<B>();
}

class _TextFieldShellState<B extends TextFieldBone> extends State<TextFieldShell<B>> {
  FormSkeleton _skeleton;
  B _bone;
  TextFieldSheet _sheet = const TextFieldSheet();

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _bone = widget.bone??BoneProvider.of<B>(context);
    assert(_bone != null);
    _subscription = _bone.outFieldSheet.listen(_updateSheet);

    _skeleton = (widget.skeleton??BoneProvider.of<FormSkeleton>(context))..addField(_bone);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _skeleton.removeField(_bone);
    super.dispose();
  }

  void _updateSheet(FieldSheet sheet) {
    if (sheet != null)
      setState(() {
        _sheet = sheet;
      });
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      initialValue: _sheet.value == null ? _sheet.value : _sheet.value.toString(),

      focusNode: _bone.focusNode,

      decoration: widget.decorator(_sheet, _bone),

      keyboardType: _sheet.keyboardType,

      obscureText: _sheet.obscureText,
      maxLength: _sheet.maxLength,

      onFieldSubmitted: _skeleton.onFieldSubmitted(context, _bone),
      onSaved: _bone.onSaved,
      validator: _bone.validator,

      inputFormatters: _sheet.inputFormatters,
    );
  }
}