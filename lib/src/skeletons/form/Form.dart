import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/area/SafeArea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class FieldShell implements StatefulWidget {
  FieldBoneBase get bone;
}

mixin FieldStateMixin<WidgetType extends FieldShell> on State<WidgetType> {
  FormSkeleton _formBone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newFormBone = FormBone.of(context);
    if (_formBone != newFormBone) {
      _formBone?.removeField(widget.bone);
      _formBone = newFormBone;
      _formBone.addField(widget.bone);
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _formBone.removeField(oldWidget.bone);
      _formBone.addField(widget.bone);
    }
  }

  @override
  void dispose() {
    _formBone?.removeField(widget.bone);
    super.dispose();
  }
}

abstract class FieldState<WidgetType extends FieldShell> extends State<WidgetType>
    with FieldStateMixin {}

abstract class FieldBoneBase extends Bone implements SafePeopleSkeleton {}

mixin FieldSkeletonBase implements FieldBoneBase {}

abstract class FieldBone<V> extends FieldBoneBase {
  Stream<V> get outValue;
  Stream<V> get outTmpValue;
  Stream<FieldError> get outError;
  void inTmpValue(V tmpValue);
  Future<bool> _validation();
  void _save();
}

abstract class FieldSkeleton<V> extends Skeleton
    with SafePeopleSkeleton, FieldSkeletonBase
    implements FieldBone<V> {
  final List<FieldValidator<V>> validators;

  FieldSkeleton({
    V seed,
    List<FieldValidator<V>> validators,
  })  : _valueController = BehaviorSubject.seeded(seed),
        _tmpValueController = BehaviorSubject.seeded(seed),
        this.validators = validators ?? [];

  final BehaviorSubject<V> _valueController;
  Stream<V> get outValue => _valueController;
  V get value => _valueController.value;
  void inValue(V value) {
    _valueController.add(value);
    inTmpValue(value);
  }

  final BehaviorSubject<V> _tmpValueController;
  Stream<V> get outTmpValue => _tmpValueController;
  V get tmpValue => _tmpValueController.value;
  @override
  void inTmpValue(V value) => _tmpValueController.add(value);

  final BehaviorSubject<FieldError> _errorController = BehaviorSubject.seeded(null);
  Stream<FieldError> get outError => _errorController;
  FieldError get error => _errorController.value;
  void inError(FieldError error) {
    if (_errorController.value != error) _errorController.add(error);
  }

  V _valueForSave;

  @override
  Future<bool> _validation() {
    _valueForSave = tmpValue;
    return () async {
      try {
        for (var validator in validators) {
          final error = await validator(_valueForSave);
          if (error != null) {
            inError(error);
            return false;
          }
        }
        inError(null);
        return true;
      } catch (exc) {
        inError(FieldError.$exception);
        return false;
      }
    }();
  }

  @override
  void _save() => inValue(_valueForSave);
}

typedef InputDecoration FieldDecorator<S>(S fieldBone);
typedef Future<FieldError> FieldValidator<V>(V value);
typedef Translations FieldErrorTranslator(FieldError error);

TranslationsConst basicNoisy(FieldError error) {
  switch (error?.code) {
    case FieldError.exception:
      return TranslationsConst(
        it: "C'è stato un errore improvviso, controlla il campo",
      );

    case FieldError.undefined:
      return TranslationsConst(
        it: "Campo non definito",
      );

    case FieldError.invalid:
      return TranslationsConst(
        it: "Il campo non è valido.",
      );
    default:
      // ignore: deprecated_member_use_from_same_package
      return byPassNoisy(error);
  }
}

@deprecated
TranslationsConst byPassNoisy(FieldError error) {
  return error == null ? null : TranslationsConst(en: error.code);
}

class FieldError {
  static const String exception = "EXCEPTION", undefined = "UNDEFINED", invalid = "INVALID";
  static const FieldError $exception = FieldError(exception);
  static const FieldError $undefined = FieldError(undefined);
  static const FieldError $invalid = FieldError(invalid);

  final String code;
  final Object data;

  const FieldError(this.code, [this.data]);

  @override
  String toString() => "FieldError(code: $code, data: $data)";
}

class ValueFieldValidator {
  static List<FieldValidator<FieldError>> get base => [undefined];
  static Future<FieldError> undefined(value) async {
    if (value == null) return FieldError.$undefined;
    return null;
  }
}

//enum FieldState {
//  active,
//  working,
//  completed,
//}

/// Form Controller

abstract class FormBone implements Bone {
  List<FieldBoneBase> get _fields;
  void addField(FieldBoneBase field) {
    assert(field != null);
    _fields.add(field);
  }

  void removeField(FieldBoneBase field) => _fields.remove(field);

  Future<bool> validation();
  void save();
  Future<bool> submit(AsyncCallback worker);

  factory FormBone.of(BuildContext context) => BoneProvider.of(context);
}

class FormSkeleton extends Skeleton with FormBone {
  final List<FieldBoneBase> _fields = [];

  Future<bool> validation() async {
    bool isValid = true;

    await Future.wait(_fields.map((field) async {
      if (field is FieldBone) {
        final res = await field._validation();
        if (!res) isValid = false;
      }
    }).toList());

    return isValid;
  }

  void save() {
    _fields.forEach((field) {
      if (field is FieldBone) field._save();
    });
  }

  Future<bool> submit(AsyncCallback worker) async {
    if (!await validation()) return false;
    save();
    await worker();
    return true;
  }
}

class FormProvider extends StatefulWidget {
  final FormBone bone;
  final Widget child;

  const FormProvider({
    Key key,
    this.bone,
    this.child,
  }) : super(key: key);

  @override
  _FormProviderState createState() => _FormProviderState();
}

class _FormProviderState extends State<FormProvider> {
  FormBone _form;
  SafeAreaBone _safeArea;
  FocuserBone _focuser;

  @override
  void initState() {
    super.initState();
    if (widget.bone == null) _form = FormSkeleton();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSafeArea = SafeAreaBone.of(context, true);
    if (newSafeArea != null && _safeArea != null) {
      (_safeArea).dispose();
      _safeArea = null;
    } else if (_safeArea == null) {
      _safeArea = SafeAreaBone();
    }
    final newFocuser = FocuserBone.of(context, true);
    if (newFocuser != null && _focuser != null) {
      (_focuser as Skeleton).dispose();
      _focuser = null;
    } else if (_focuser == null) {
      _focuser = FocuserSkeleton();
    }
    if (_focuser != null && _focuser is FocuserSkeleton)
      (_focuser as FocuserSkeleton).focusScope = FocusScope.of(context);
  }

  @override
  void didUpdateWidget(FormProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone == oldWidget.bone) return;
    if (widget.bone == null) {
      _form = FormSkeleton();
    } else {
      (_form as Skeleton).dispose();
      _form = widget.bone;
    }
  }

  @override
  void dispose() {
    if (_safeArea != null) _safeArea.dispose();
    if (_focuser != null) (_focuser as Skeleton).dispose();
    if (widget.bone == null) (_form as Skeleton).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _safeArea == null && _focuser == null
        ? BoneProvider<FormBone>(
            bone: _form,
            child: widget.child,
          )
        : BoneProviderTree(
            boneProviders: [
              BoneProvider<FormBone>.tree(_form),
              if (_safeArea != null) BoneProvider<SafeAreaBone>.tree(_safeArea),
              if (_focuser != null) BoneProvider<FocuserBone>.tree(_focuser),
            ],
            child: widget.child,
          );
  }
}
