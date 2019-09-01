import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/Widgets.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OptionsFieldSheet<V> {
  final List<V> values;

  final bool isEnable;

  const OptionsFieldSheet({
    this.values: const [],
    this.isEnable: true,
  }) : assert(isEnable != null);

  OptionsFieldSheet<V> copyWith({
    V tmpValue,
    List<DropdownMenuItem<V>> items,
    bool isEnable,
  }) {
    return OptionsFieldSheet(
      values: items ?? this.values,
      isEnable: isEnable ?? this.isEnable,
    );
  }
}

abstract class OptionsFieldBone<V> extends FieldBone<V> {
  Stream<OptionsFieldSheet<V>> get outSheet;
  Stream<Data2<V, OptionsFieldSheet<V>>> get outTmpValueAndSheet;
  Stream<Data2<FieldError, bool>> get outErrorAndIsEmpty;
}

class OptionsFieldSkeleton<V> extends FieldSkeleton<V> implements OptionsFieldBone<V> {
  OptionsFieldSkeleton({
    OptionsFieldSheet<V> sheet: const OptionsFieldSheet(),
    FieldError error,
    List<FieldValidator<V>> validators,
  })  : assert(sheet != null),
        this._sheetController = BehaviorSubject.seeded(sheet),
        super(
          validators: validators ?? [OptionsFieldValidator.notEmpty],
        );

  @override
  void dispose() {
    _sheetController.close();
    super.dispose();
  }

  BehaviorSubject<OptionsFieldSheet<V>> _sheetController;
  Stream<OptionsFieldSheet<V>> get outSheet => _sheetController;
  OptionsFieldSheet get sheet => _sheetController.value;
  Future<void> inSheet(OptionsFieldSheet sheet) async => _sheetController.add(sheet);

  Stream<Data2<V, OptionsFieldSheet<V>>> _outTmpValueAndSheet;
  Stream<Data2<V, OptionsFieldSheet<V>>> get outTmpValueAndSheet {
    if (_outTmpValueAndSheet == null)
      _outTmpValueAndSheet = Data2.combineLatest(outTmpValue, outSheet);
    return _outTmpValueAndSheet;
  }

  Stream<Data2<FieldError, bool>> _outErrorAndIsEmpty;
  Stream<Data2<FieldError, bool>> get outErrorAndIsEmpty {
    outTmpValue.listen(print);
    if (_outErrorAndIsEmpty == null)
      _outErrorAndIsEmpty =
          Observable.combineLatest2(outError, outTmpValue, _combinerErrorAndIsEmpty)
              .shareValueSeeded(_combinerErrorAndIsEmpty(error, tmpValue));
    return _outErrorAndIsEmpty;
  }

  Data2<FieldError, bool> _combinerErrorAndIsEmpty(FieldError error, V tmpValue) {
    return Data2(error, tmpValue == null);
  }

  @override
  Future<void> inFieldState(FieldState state) =>
      inSheet(sheet.copyWith(isEnable: state == FieldState.active));
}

class OptionsFieldShell<V> extends StatefulWidget implements FieldShell {
  final OptionsFieldBone<V> bone;

  final ValueBuilder<V> builder;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const OptionsFieldShell(
    this.builder, {
    Key key,
    @required this.bone,
    this.nosy: basicNoisy,
    this.decoration: const TranslationsInputDecoration(
      translationsHintText: const TranslationsConst(
        it: "Seleziona un valore",
        en: "Choise a value",
      ),
    ),
  })  : assert(bone != null),
        assert(builder != null),
        super(key: key);

  @override
  _OptionsFieldShellState<V> createState() => _OptionsFieldShellState<V>();
}

class _OptionsFieldShellState<V> extends State<OptionsFieldShell<V>> with FieldStateMixin {
  ObservableSubscriber<Data2<FieldError, bool>> _dataSubscriber;
  Data2<FieldError, bool> _data;

  @override
  void initState() {
    super.initState();
    _dataSubscriber = ObservableSubscriber(_dataListener)
      ..subscribe(widget.bone.outErrorAndIsEmpty);
  }

  @override
  void didUpdateWidget(OptionsFieldShell<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _dataSubscriber
        ..unsubscribe()
        ..subscribe(widget.bone.outErrorAndIsEmpty);
    }
  }

  @override
  void dispose() {
    _dataSubscriber.unsubscribe();
    super.dispose();
  }

  void _dataListener(ObservableState<Data2<FieldError, bool>> update) {
    setState(() => _data = update.data);
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: widget.decoration.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
            errorText: widget.nosy(_data.data1)?.text,
            errorMaxLines: widget.decoration.errorMaxLines ?? 2,
          ),
      isEmpty: _data.data2,
      child: DropdownButtonHideUnderline(
        child: ObservableBuilder<Data2<V, OptionsFieldSheet<V>>>(
            builder: (_, data, state) {
              return DropdownButton<V>(
                isDense: true,
                value: data.data1,
                items: data.data2.values.map((value) {
                  return DropdownMenuItem<V>(
                    value: value,
                    child: widget.builder(context, value),
                  );
                }).toList(),
                onChanged: data.data2.isEnable ? widget.bone.inTmpValue : null,
              );
            },
            stream: widget.bone.outTmpValueAndSheet),
      ),
    );
  }
}

class OptionsFieldValidator {
  static Future<FieldError> notEmpty<V>(V value) async {
    if (value == null) return OptionsFieldError.undefined;
    return null;
  }
}

class OptionsFieldError {
  static const undefined = FieldError.$undefined;
}
