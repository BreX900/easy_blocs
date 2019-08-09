import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/Widgets.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/material.dart';


class OptionsFieldShield<V> {
  final List<V> values;

  const OptionsFieldShield({this.values: const []});

  OptionsFieldShield<V> copyWith({
    List<DropdownMenuItem<V>> items,
  }) {
    return OptionsFieldShield(
      values: items??this.values,
    );
  }
}


abstract class OptionsFieldBone<V> extends FieldBone<V> {
  OptionsFieldShield<V> shield;
}


class OptionsFieldSkeleton<V> extends FieldSkeleton<V> implements OptionsFieldBone<V> {
  OptionsFieldSkeleton({
    V value, OptionsFieldShield<V> shield: const OptionsFieldShield(),
    List<FieldValidator<V>> validators,
  }) : assert(shield != null), this._shield = shield, super(
    value: value,
    validators: validators??[OptionsFieldValidator.notEmpty],
  );

  OptionsFieldShield<V> _shield;
  OptionsFieldShield<V> get shield => _shield;
  set shield(OptionsFieldShield<V> shield) {
    if (_shield != shield) {
      _shield = shield;
      notifyListeners();
    }
  }
}


class OptionsFieldShell<V> extends StatefulWidget {
  final OptionsFieldBone<V> bone;

  final ValueBuilder<V> builder;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const OptionsFieldShell(this.builder, {Key key,
    @required this.bone,
    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
  }) :
        assert(bone != null),
        assert(builder != null), super(key: key);

  static InputDecoration _basicDecorator(_) => const TranslationsInputDecoration(
    translationsHintText: const TranslationsConst(
      it: "Seleziona un valore",
      en: "Choise a value",
    ),
  );

  @override
  _OptionsFieldShellState<V> createState() => _OptionsFieldShellState<V>();
}

class _OptionsFieldShellState<V> extends State<OptionsFieldShell<V>> {
  V _value;
  V _tmpValue;

  @override
  void initState() {
    super.initState();
    _value = widget.bone.value;
    _tmpValue = _value;
  }

  @override
  void didUpdateWidget(OptionsFieldShell<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_value != widget.bone.value) {
      _tmpValue = _value;
    }
  }

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<V>(
      value: _tmpValue,
      items: widget.bone.shield.values.map((value) {

        return DropdownMenuItem<V>(
          value: value,
          child: widget.builder(context, value),
        );
      }).toList(),
      onChanged: (value) => setState(() => _tmpValue = value),
      onSaved: (value) => widget.bone.onSaved(value),
      validator: (value) => widget.nosy(widget.bone.validator(value))?.text,
      decoration: widget.decoration,
    );
  }
}


class OptionsFieldValidator {
  static FieldError notEmpty<V>(V value) {
    if (value == null)
      return OptionsFieldError.undefined;
    return null;
  }
}

class OptionsFieldError {
  static const undefined = FieldError.undefined;
}