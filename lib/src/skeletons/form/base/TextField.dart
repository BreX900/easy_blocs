import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/skeletons/form/base/IntField.dart';
import 'package:easy_blocs/src/skeletons/form/base/PriceField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rational/rational.dart';

class TextFieldShield {
  final TextInputType keyboardType;

  final bool obscureText;
  final int maxLength;

  final List<TextInputFormatter> inputFormatters;

  const TextFieldShield({
    this.keyboardType,
    this.obscureText: false, this.maxLength,
    this.inputFormatters,
  });

  TextFieldShield copyWith({
    TextInputType keyboardType,
    bool obscureText, int maxLength,
    List<TextInputFormatter> inputFormatters,
  }) {
    return TextFieldShield(
      keyboardType: keyboardType??this.keyboardType,
      obscureText: obscureText??this.obscureText,
      maxLength: maxLength??this.maxLength,
      inputFormatters: inputFormatters??this.inputFormatters,
    );
  }
}

abstract class TextFieldBone extends FieldBone<String> {
  TextFieldShield shield;
}


class TextFieldSkeleton extends FieldSkeleton<String> implements TextFieldBone {
  TextFieldSkeleton({
    String value,
    List<FieldValidator<String>> validators,
  }): super(
    value: value,
    validators: validators??[TextFieldValidator.undefined],
  );

  TextFieldShield _shield;
  TextFieldShield get shield => _shield;
  set shield(TextFieldShield shield) {
    if (_shield != shield) {
      _shield = shield;
      notifyListeners();
    }
  }
}

/// Il valore initialValue se cambiato non porta nessuna modifica per ciò è da racchiudere tutti
/// i valori in transizioni e non ha senso tentare di aggiornarli in seguito
class TextFieldShell extends StatefulWidget implements FocusShell {
  final TextFieldBone bone;
  TextFieldShield get shield => bone.shield;
  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const TextFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,
    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
  }) :
        assert(bone != null),
        assert(decoration != null),
        super(key: key);

  @override
  TextFieldShellState createState() => TextFieldShellState();
}

class TextFieldShellState extends State<TextFieldShell> with FocusShellStateMixin {
  TextEditingController _controller;
  String _value;

  @override
  void initState() {
    super.initState();
    assert(widget.bone != null);
    _value = widget.bone.value;
    _controller = TextEditingController(text: widget.bone.value);
    assert(widget.shield != null);
  }

  @override
  void didUpdateWidget(TextFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_value != widget.bone.value) {
      _value = widget.bone.value;
      _controller.text = _value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: _controller,

      focusNode: focusNode,

      decoration: widget.decoration,

      keyboardType: widget.shield.keyboardType,

      obscureText: widget.shield.obscureText,
      maxLength: widget.shield.maxLength,

      onFieldSubmitted: (_) => nextFocus(),

      onSaved: widget.bone.onSaved,
      validator: (value) => widget.nosy(widget.bone.validator(value))?.text,

      inputFormatters: widget.shield.inputFormatters,
    );
  }
}


abstract class TextFieldValidator {
  static const List<FieldValidator<String>> base =  [
    undefined,
  ];

  static FieldError undefined(String value) {
    if (value == null || value.isEmpty)
      return TextFieldError.undefined;
    return null;
  }
}

class TextFieldError {
  static const undefined = FieldError.undefined;
  static const invalid = FieldError.invalid;
}


typedef String _Writer<V>(V value);
typedef V _Reader<V>(String value);
class TextFieldAdapter<S extends FieldSkeleton<V>, V> extends TextFieldBone {
  final S skeleton;

  final _Writer<V> _writer;
  @override
  String get value => skeleton.value == null ? null : _writer(skeleton.value);

  final _Reader<V> _reader;

  TextFieldAdapter(this.skeleton, this._writer, this._reader, [TextFieldShield shield = const TextFieldShield()]) {
    _shield = shield;

  }

  static TextFieldAdapter<IntFieldSkeleton, int> integer(IntFieldSkeleton skeleton) {
    return TextFieldAdapter(skeleton, IntFieldSkeleton.writer, IntFieldSkeleton.reader, const TextFieldShield(
      keyboardType: TextInputType.number,
    ));
  }
  static TextFieldAdapter<PriceFieldSkeleton, Rational> price(PriceFieldSkeleton skeleton) {

    return TextFieldAdapter(skeleton, PriceFieldSkeleton.writer, PriceFieldSkeleton.reader, const TextFieldShield(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ));
  }

  V get parseValue => skeleton.value;

  TextFieldShield _shield;
  TextFieldShield get shield => _shield;
  set shield(TextFieldShield shield) {
    if (_shield != shield) {
      _shield = shield;
      notifyListeners();
    }
  }

  @override
  FieldError validator(String value) {
    if (value == null)
      return skeleton.validator(null);
    final res = _reader(value);
    if (res == null)
      return TextFieldError.invalid;
    return skeleton.validator(res);
  }

  @override
  void onSaved(String value) => skeleton.value = _reader(value);

  @override
  void addListener(VoidCallback listener) => skeleton.addListener(listener);

  @override
  void dispose() => skeleton.dispose();

  @override
  bool get hasListeners => skeleton.hasListeners;

  @override
  // ignore: invalid_use_of_protected_member
  Future<void> notifyListeners() => skeleton.notifyListeners();

  @override
  void removeListener(VoidCallback listener) => skeleton.removeListener(listener);
}