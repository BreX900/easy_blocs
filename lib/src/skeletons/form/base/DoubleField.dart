//import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
//import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//
//class DoubleFieldSheet extends FieldSheet<double> {
//  const DoubleFieldSheet() : super();
//}
//
//
//abstract class IntFieldBone extends FieldBone<int, IntFieldSheet> {}
//
//
//class IntFieldSkeleton extends FieldSkeleton<int, IntFieldSheet> implements IntFieldBone {
//  IntFieldSkeleton({
//    IntFieldSheet initialValue: const IntFieldSheet(),
//    List<FieldValidator<int>> validators,
//  }) : super(
//    initialValue: initialValue,
//    validators: validators??[],
//  );
//
//  @override
//  void onSaved(int value) => inSheet(sheet.copyWith(value: value));
//}
//
//
//class IntFieldShell extends StatefulWidget implements FocusShell {
//  final IntFieldBone fieldBone;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  final FieldErrorTranslator nosy;
//  final InputDecoration decoration;
//
//  const IntFieldShell({Key key,
//    @required this.fieldBone,
//    this.mapFocusBone, this.focusNode,
//
//    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
//  }) :
//        assert(fieldBone != null),
//        assert(decoration != null), super(key: key);
//
//  @override
//  _IntFieldShellState createState() => _IntFieldShellState();
//}
//
//class _IntFieldShellState extends State<IntFieldShell> with FocusShellStateMixin {
//
//  IntFieldBone get fieldBone => widget.fieldBone;
//  IntFieldSheet get fieldSheet => widget.fieldBone.sheet;
//
//  @override
//  Widget build(BuildContext context) {
//    assert(fieldSheet != null);
//
//    return FormField<int>(
//      initialValue: fieldBone.sheet.value,
//      onSaved: fieldBone.onSaved,
//      validator: (value) => widget.nosy(fieldBone.validator(value))?.text,
//      builder: (FormFieldState<int> state) {
//
//        return TextField(
//          focusNode: focusNode,
//          onChanged: (text) {
//            // ignore: invalid_use_of_protected_member
//            state.setValue(int.tryParse(text));
//          },
//          onSubmitted: (_) => nextFocus(),
//          decoration: widget.decoration.copyWith(
//            errorText: state.errorText,
//          ),
//        );
//      },
//    );
//  }
//}
//
//
//
//class IntFieldValidator {
//
//  static FieldError undefined(int num) {
//    if (num == null)
//      return IntFieldError.undefined;
//    return null;
//  }
//
//  static FieldValidator<int> max(int max) {
//    assert(max != null);
//    return (int value) {
//      if (value > max)
//        return IntFieldError.min;
//      return null;
//    };
//  }
//
//  static FieldValidator<int> min(int min) {
//    assert(min != null);
//    return (int value) {
//      if (value < min)
//        return IntFieldError.min;
//      return null;
//    };
//  }
//
////  FieldError notInt(String value) {
////    final integer = int.tryParse(value);
////    if (integer == null)
////      return IntFieldError.notNumber;
////    for (var validator in validators) {
////      final error = validator(integer);
////      if (error != null)
////        return error;
////    }
////    return null;
////  }
//
//
//}
//
//class IntFieldError {
//  static const undefined = FieldError.undefined;
//  static const max = FieldError("MAX");
//  static const min = FieldError("MIN");
//}