//import 'dart:async';
//
//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/form/dropdown_button/OptionsFieldBone.dart';
//import 'package:easy_blocs/src/skeletons/form/dropdown_button/OptionsFieldSheet.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:easy_blocs/src/translator/Widgets.dart';
//import 'package:easy_blocs/src/utility.dart';
//import 'package:flutter/material.dart';
//
//
//class OptionsFieldShell<V> extends StatefulWidget
//    implements FieldShell<OptionsFieldBone<V>> {
//  @override
//  final OptionsFieldBone<V> fieldBone;
//
//  final ValueBuilder<V> builder;
//
//  @override
//  final FieldErrorTranslator nosy;
//  final FieldDecorator<_OptionsFieldShellState<V>> decorator;
//
//  const OptionsFieldShell({Key key,
//    this.fieldBone,
//    @required this.builder,
//    this.nosy, this.decorator: _basicDecorator,
//  }) : assert(builder != null), super(key: key);
//
//  static InputDecoration _basicDecorator(_) => const TranslationsInputDecoration(
//    translationsHintText: const TranslationsConst(
//      it: "Seleziona un valore",
//      en: "Choise a value",
//    ),
//  );
//
//  @override
//  _OptionsFieldShellState<V> createState() => _OptionsFieldShellState<V>();
//}
//
//class _OptionsFieldShellState<V> extends State<OptionsFieldShell<V>>
//    with FieldShellStateMixin<OptionsFieldBone<V>, OptionsFieldShell<V>> {
//
//  OptionsFieldSheet _sheet = const OptionsFieldSheet();
//  OptionsFieldSheet get sheet => _sheet;
//
//  @override
//  StreamSubscription subscribeSheet() {
//    return fieldBone.outFieldSheet.listen((sheet) {
//      setState(() {
//        _sheet = sheet;
//      });
//    });
//  }
//
//  V _tmpValue;
//
//  @override
//  Widget build(BuildContext context) {
//    //final theme = Theme.of(context).inputDecorationTheme;
//    return DropdownButtonFormField<V>(
//      value: _tmpValue??sheet.value,
//      onChanged: (value) => setState(() => _tmpValue = value),
//      items: sheet.values.map((value) {
//
//        return DropdownMenuItem<V>(
//          value: value,
//          child: widget.builder(context, value),
//        );
//      }).toList(),
//      onSaved: fieldBone.onSaved,
//      validator: nosy<V>(),
//      decoration: widget.decorator(this),
//    );
//  }
//}



//class DropdownButtonShell<V> extends FocusFieldBuilder<V, DropdownButtonSheet<V>, DropdownButtonFieldBone<V>> {
//
//  DropdownButtonShell({Key key,
//    FormBone formBone, DropdownButtonFieldBone<V> bone,
//    MapFocusBone automaticFocusBone, FocusNode focusNode,
//    FieldShellDecorator<DropdownButtonFieldBone<V>, DropdownButtonSheet<V>> decorator: _decorator,
//  }) : super(key: key,
//    formBone: formBone, bone: bone,
//    automaticFocusBone: automaticFocusBone, focusNode: focusNode,
//    builder: (DropdownButtonFieldBone<V> bone, DropdownButtonSheet<V> sheet,
//        MapFocusBone automaticFocusBone) {
//
//    return DropdownButtonFormField(
//        value: sheet.value,
//        items: sheet.items,
//        onSaved: bone.onSaved,
//        validator: bone.validator,
//        decoration: decorator(bone, sheet),
//      );
//    },
//  );
//
//  static InputDecoration _decorator(bone, sheet) => null;
//
//}

