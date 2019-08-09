//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
//import 'package:flutter/material.dart';
//
//
//typedef InputDecoration FieldDecorator<S>(S fieldBone);
//typedef FieldError FieldValidator<V>(V value);
//typedef Translations FieldErrorTranslator(FieldError error);
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
//class ValueFieldValidator {
//  static FieldError notUndefined(value) {
//    if (value == null)
//      return FieldError.undefined;
//    return null;
//  }
//}
//
//
//abstract class FieldShell<B extends FieldBone> implements StatefulWidget {
//  B get fieldBone;
//  FieldErrorTranslator get nosy;
//}
//
//mixin FieldShellStateMixin<B extends FieldBone, WidgetType extends FieldShell<B>> on State<WidgetType> {
//  B _fieldBone;
//  B get fieldBone => _fieldBone;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _updateForm();
//  }
//
//  @override
//  void didUpdateWidget(WidgetType oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.fieldBone != oldWidget.fieldBone)
//      _updateForm();
//  }
//
//  void _updateForm() {
//    final bone = widget.fieldBone??BoneProvider.of<B>(context);
//    assert(bone != null);
//
//    if (_fieldBone == bone)
//      return;
//
//    _fieldBone = bone;
//  }
//
//  ValueChanged<V> nosy<V>() {
//    return (value) => widget.nosy(fieldBone.validator(value))?.text;
//  }
//}
//
//
//class TranslationsError extends TranslationsConst {
//  final String code;
//
//  const TranslationsError(this.code, {String it, String en}) : super(it: it, en: en);
//}


//typedef Widget _FieldBuilder<V, S extends FieldSheet, B extends FieldBone<V, S>>(
//    B bone, S sheet, MapFocusBone automaticFocusBone);
//
//class FocusFieldBuilder<V, S extends FieldSheet, B extends FieldBone<V, S>> extends StatefulWidget {
//  final FormBone formBone;
//  final B bone;
//
//  final MapFocusBone automaticFocusBone;
//  final FocusNode focusNode;
//
//  final _FieldBuilder<V, S, B> builder;
//
//  const FocusFieldBuilder({Key key,
//    this.formBone, this.bone,
//    this.automaticFocusBone, this.focusNode,
//    @required this.builder,
//  }) : super(key: key);
//
//  @override
//  FocusFieldBuilderState<V, S, B> createState() => FocusFieldBuilderState<V, S, B>();
//}
//
//class FocusFieldBuilderState<V, S extends FieldSheet, B extends FieldBone<V, S>>
//    extends State<FocusFieldBuilder<V, S, B>> {
//
//  FormBone _formBone;
//  B _bone;
//  S _sheet;
//  StreamSubscription _subscription;
//
//  FocusNode _focusNode;
//  MapFocusBone _automaticFocusBone;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _updateForm();
//    _updateFocus();
//  }
//
//  @override
//  void didUpdateWidget(FocusFieldBuilder<V, S, B> oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.formBone != oldWidget.formBone || widget.bone != oldWidget.bone)
//      _updateForm();
//    if (widget.automaticFocusBone != oldWidget.automaticFocusBone
//        || widget.focusNode != oldWidget.focusNode)
//      _updateFocus();
//  }
//
//  @override
//  void dispose() {
//    _formBone.removeField(_bone);
//    _subscription.cancel();
//    _automaticFocusBone?.removePointOfFocus(_focusNode);
//    super.dispose();
//  }
//
//  void _updateForm() {
//    final formBone = widget.formBone??BoneProvider.of<FormSkeleton>(context);
//    final bone = widget.bone??BoneProvider.of<B>(context);
//    assert(formBone != null && bone != null, "$formBone - $bone");
//
//    if (_formBone == formBone && _bone == bone)
//      return;
//
//    if (_bone != null) {
//      _formBone.removeField(_bone);
//      _subscription = _bone.outFieldSheet.listen(_updateSheet);
//    }
//    _formBone = formBone;
//    _bone = bone;
//    _formBone.addField(_bone);
//  }
//
//  void _updateFocus() {
//    if (widget.focusNode == null && _focusNode == null)
//      return;
//
//    final automaticFocus = widget.automaticFocusBone ?? BoneProvider.of<MapFocusBone>(context);
//    assert(automaticFocus != null);
//
//    if (_automaticFocusBone == automaticFocus && _focusNode == widget.focusNode)
//      return;
//    if (_focusNode != null)
//      _automaticFocusBone.removePointOfFocus(_focusNode);
//    _focusNode = widget.focusNode;
//    _automaticFocusBone.addPointOfFocus(_focusNode);
//  }
//
//  void _updateSheet(FieldSheet sheet) {
//    if (sheet != null)
//      setState(() {
//        _sheet = sheet;
//      });
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    return widget.builder(_bone, _sheet, _automaticFocusBone);
//  }
//}