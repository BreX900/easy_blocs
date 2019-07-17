import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
import 'package:flutter/material.dart';


class DropdownButtonSheet<V> extends FieldSheet<V> {
  final List<DropdownMenuItem<V>> items;

  DropdownButtonSheet({V value, this.items}) : super(
    value: value,
  );

  DropdownButtonSheet<V> copyWith({
    V value, List<DropdownMenuItem<V>> items, InputDecoration decoration,
  }) {
    return DropdownButtonSheet(
      value: value??this.value,
      items: items??this.items,
    );
  }
}