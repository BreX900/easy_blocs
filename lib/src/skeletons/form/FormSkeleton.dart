import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/form/button/ButtonFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/button/ButtonFieldSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
import 'package:flutter/material.dart';


class FormSkeleton extends Skeleton {
  final GlobalKey<FormState> formKey;

  final List<FieldBone> _fields = List();

  List<ButtonFieldBone> _buttons;

  FormSkeleton({GlobalKey<FormState> formKey}) : this.formKey = formKey??GlobalKey<FormState>();

  void addField(FieldBone field) {
    if (!_fields.contains(field)) {
      _fields.add(field);
    }
  }
  void removeField(FieldBone field) {
    _fields.remove(field);
  }

  void addButton(ButtonFieldBone field) {
    if (field.focusNode != null) {
      assert(_buttons.any((button) => button.focusNode != null), "Only One Button in Form With FocusNode");
    }
    _buttons.add(field);
  }
  void removeButton(ButtonFieldBone field) {
    _buttons.remove(field);
  }


  ButtonFieldSkeleton get focusButton => _buttons.firstWhere((button) => button.focusNode != null,
      orElse: () => null
  );

  ValueChanged<String> onFieldSubmitted(BuildContext context, FieldBone field) {
    return (String value) {
      final indexNextManager = _fields.indexOf(field)+1;
      final nextFocusNode = indexNextManager < _fields.length
          ? _fields[indexNextManager].focusNode
          : focusButton?.focusNode;

      if (nextFocusNode != null)
        Future.delayed(Duration(milliseconds: 300),
                () => FocusScope.of(context).requestFocus(nextFocusNode));
    };
  }
}










