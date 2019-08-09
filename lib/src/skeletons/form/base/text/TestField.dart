//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/translator/TranslationsModel.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//typedef InputDecoration FieldDecorator<S>(S fieldBone);
//typedef FieldError FieldValidator<V>(V value);
//typedef Translations FieldErrorTranslator(FieldError error);
//
//TranslationsConst byPassNoisy(FieldError error) {
//  return error == null ? null : TranslationsConst(en: error.code);
//}
//
//class FieldError {
//  static const undefined = FieldError("NULL");
//
//  final String code;
//  final Object data;
//
//  const FieldError(this.code, [this.data]);
//}
//
//
//class ValueFieldValidator<I> {
//  static FieldError notUndefined(value) {
//    if (value == null)
//      return FieldError.undefined;
//    return null;
//  }
//}
//
//
//abstract class InputFieldBone<I> extends Bone {
//  void onSaved(I value);
//  FieldError validator(I value);
//
//  set isAttach(bool isAttach);
//}
//abstract class OutputFieldBone<O> extends Bone {
//  O get value;
//}
//abstract class FieldBone<I, O> extends Bone implements InputFieldBone<I>, OutputFieldBone<O> {}
//
//
//abstract class FieldSkeleton<I, O> extends Skeleton implements FieldBone<I, O> {
//  final List<FieldValidator<I>> validators;
//
//  FieldSkeleton({
//    I initialValue,
//    this.validators,
//  }) : assert(initialValue != null), this._value = initialValue;
//
//  O _value;
//  O get value => _value;
//  @protected
//  set value(O value) => _value = value;
//
//  @override
//  FieldError validator(I value) {
//    for (var validator in validators) {
//      final error = validator(value);
//      if (error != null)
//        return error;
//    }
//    return null;
//  }
//
//  void check(O value) async {
//    assert(_isAttach == false, "The initialValue in form not change after init");
//    if (value != null && value != _value)
//      _value = value;
//  }
//  @override
//  void onSaved(I value) => _value = value;
//
//  bool _isAttach = false;
//  set isAttach(bool isAttach) {
//    assert(_isAttach == false || isAttach == false);
//    _isAttach = isAttach;
//  }
//}
//
//
//class TextFieldShield {
//  final TextInputType keyboardType;
//
//  final bool obscureText;
//  final int maxLength;
//
//  final List<TextInputFormatter> inputFormatters;
//
//  const TextFieldShield({
//    this.keyboardType,
//    this.obscureText: false, this.maxLength,
//    this.inputFormatters,
//  });
//
//  TextFieldShield copyWith({
//    Object value,
//    TextInputType keyboardType,
//    bool obscureText, int maxLength,
//    List<TextInputFormatter> inputFormatters,
//  }) {
//    return TextFieldShield(
//      keyboardType: keyboardType??this.keyboardType,
//      obscureText: obscureText??this.obscureText,
//      maxLength: maxLength??this.maxLength,
//      inputFormatters: inputFormatters??this.inputFormatters,
//    );
//  }
//}
//
//
//abstract class TextFieldBone<O> extends FieldBone<String, O> {
//  void inShield(TextFieldShield shield);
//}
//class IntFieldSkeleton extends TextFieldSkeletonBase<int> {
//  IntFieldSkeleton({
//    int initialValue,
//    List<FieldValidator<String>> validators: TextFieldValidator.base,
//    List<FieldValidator<int>> intValidators,
//  }): super(
//    initialValue: initialValue,
//    validators: validators,
//  ) {
//    validators.add((text) {
//      intValidators.forEach((validator) => validator(int.tryParse(text)));
//      return null;
//    });
//  }
//}
//class PIpe<O> extends TextFieldBone<O> {
//  @override
//  void inShield(TextFieldShield shield) {}
//
//  @override
//  void set isAttach(bool isAttach) {
//    // TODO: implement isAttach
//  }
//
//  @override
//  void onSaved(String value) {
//    // TODO: implement onSaved
//  }
//
//  @override
//  FieldError validator(String value) {
//    // TODO: implement validator
//    return null;
//  }
//
//  @override
//  // TODO: implement value
//  O get value => null;
//
//}
//
//class TextFieldSkeleton extends FieldSkeleton<String, String> implements TextFieldBone<String> {
//  TextFieldSkeleton({
//    String initialValue,
//    List<FieldValidator<String>> validators: TextFieldValidator.base,
//  }): super(
//    initialValue: initialValue,
//    validators: validators,
//  );
//
//  void dispose() {
//    _shieldController.close();
//    super.dispose();
//  }
//
//  BehaviorSubject<TextFieldShield> _shieldController = BehaviorSubject.seeded(const TextFieldShield());
//  TextFieldShield get shield => _shieldController.value;
//  void inShield(TextFieldShield shield) => _shieldController.add(shield);
//}
//
//
//class TextFieldShell<O> extends StatefulWidget implements FocusShell {
//  final TextFieldBone<O> bone;
//  final TextFieldShield shield;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  final FieldErrorTranslator nosy;
//  final InputDecoration decoration;
//
//  const TextFieldShell({Key key,
//    @required this.bone,
//    @required this.shield,
//    this.mapFocusBone, this.focusNode,
//    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
//  }) :
//        assert(bone != null),
//        assert(decoration != null),
//        super(key: key);
//
//  @override
//  TextFieldShellState<O> createState() => TextFieldShellState<O>();
//}
//
//class TextFieldShellState<O> extends State<TextFieldShell<O>> with FocusShellStateMixin {
//
//  TextFieldBone<O> _bone;
//  O get value => _bone.value;
//  TextFieldShield get shield => widget.shield;
//
//  @override
//  void initState() {
//    super.initState();
//    _bone = widget.bone;
//    _bone.isAttach = true;
//  }
//
//  @override
//  void didUpdateWidget(TextFieldShell oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.bone != widget.bone) {
//      _bone.isAttach = false;
//      _bone = widget.bone;
//      _bone.isAttach = true;
//    }
//  }
//
//  @override
//  void dispose() {
//    _bone.isAttach = false;
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    assert(value != null);
//
//    return TextFormField(
//      initialValue: "$value",
//
//      focusNode: focusNode,
//
//      decoration: widget.decoration,
//
//      keyboardType: shield.keyboardType,
//
//      obscureText: shield.obscureText,
//      maxLength: shield.maxLength,
//
//      onFieldSubmitted: (_) => nextFocus(),
//
//      onSaved: _bone.onSaved,
//      validator: (value) => widget.nosy(_bone.validator(value))?.text,
//
//      inputFormatters: shield.inputFormatters,
//    );
//  }
//}
//
//
//abstract class TextFieldValidator {
//  static const List<FieldValidator<String>> base =  [
//    notEmpty,
//  ];
//
//  static FieldError notEmpty(String value) {
//    if (value == null || value.isEmpty)
//      return TextFieldError.undefined;
//    return null;
//  }
//}
//
//class TextFieldError {
//  static const undefined = FieldError.undefined;
//}