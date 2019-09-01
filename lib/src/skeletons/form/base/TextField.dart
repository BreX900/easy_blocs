import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rational/rational.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_blocs/src/skeletons/form/TextInputFormatters.dart';

class TextFieldSheet {
  final TextInputType keyboardType;

  final bool obscureText;
  final int maxLength;

  final List<TextInputFormatter> inputFormatters;

  final bool isEnable;

  const TextFieldSheet({
    this.keyboardType,
    this.obscureText: false,
    this.maxLength,
    this.inputFormatters,
    this.isEnable,
  });

  TextFieldSheet copyWith({
    FieldError error,
    TextInputType keyboardType,
    bool obscureText,
    int maxLength,
    List<TextInputFormatter> inputFormatters,
    bool isEnable,
  }) {
    return TextFieldSheet(
      keyboardType: keyboardType ?? this.keyboardType,
      obscureText: obscureText ?? this.obscureText,
      maxLength: maxLength ?? this.maxLength,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      isEnable: isEnable ?? this.isEnable,
    );
  }
}

abstract class TextFieldBone extends FieldBone<String> {
  Stream<String> get outValue;
  Stream<String> get outTmpValue;
  Stream<TextFieldSheet> get outSheet;
  Stream<Data2<FieldError, TextFieldSheet>> get outErrorAndSheet;
}

class TextFieldSkeleton extends FieldSkeleton<String> implements TextFieldBone {
  TextFieldSkeleton({
    String seed,
    List<FieldValidator<String>> validators,
    TextFieldSheet sheet: const TextFieldSheet(),
  })  : _sheetController = BehaviorSubject.seeded(sheet),
        super(
          seed: seed,
          validators: validators ?? [TextFieldValidator.undefined],
        );

  @override
  void dispose() {
    _sheetController.close();
    super.dispose();
  }

  final BehaviorSubject<TextFieldSheet> _sheetController;
  Stream<TextFieldSheet> get outSheet => _sheetController;
  TextFieldSheet get sheet => _sheetController.value;
  Future<void> inSheet(TextFieldSheet sheet) async => _sheetController.add(sheet);

  Stream<Data2<FieldError, TextFieldSheet>> _outErrorAndSheet;
  Stream<Data2<FieldError, TextFieldSheet>> get outErrorAndSheet {
    if (_outErrorAndSheet == null) _outErrorAndSheet = Data2.combineLatest(outError, outSheet);
    return _outErrorAndSheet;
  }

  @override
  Future<void> inFieldState(FieldState state) async {
    await inSheet(sheet.copyWith(isEnable: state == FieldState.active));
  }
}

/// Il valore initialValue se cambiato non porta nessuna modifica per ciò è da racchiudere tutti
/// i valori in transizioni e non ha senso tentare di aggiornarli in seguito
class TextFieldShell extends StatefulWidget implements FieldShell, FocusShell {
  final TextFieldBone bone;
  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const TextFieldShell({
    Key key,
    @required this.bone,
    this.mapFocusBone,
    this.focusNode,
    this.nosy: basicNoisy,
    this.decoration: const InputDecoration(),
  })  : assert(bone != null),
        assert(decoration != null),
        super(key: key);

  const TextFieldShell.phoneNumber({
    @required TextFieldBone bone,
    FocuserBone mapFocusBone,
    FocusNode focusNode,
    FieldErrorTranslator nosy: basicNoisy,
    InputDecoration decoration: const TranslationsInputDecoration(
      prefixIcon: Icon(Icons.phone),
      translationsHintText: TranslationsConst(
        it: "Numero del Cellulare",
        en: "Phone Number",
      ),
    ),
  }) : this(
          bone: bone,
          mapFocusBone: mapFocusBone,
          focusNode: focusNode,
          nosy: nosy,
          decoration: decoration,
        );

  @override
  TextFieldShellState createState() => TextFieldShellState();
}

class TextFieldShellState extends State<TextFieldShell> with FieldStateMixin, FocusShellStateMixin {
  final TextEditingController _controller = TextEditingController();

  ObservableSubscriber<String> _valueSubscriber;
  ObservableSubscriber<Data2<FieldError, TextFieldSheet>> _dataSubscriber;

  Data2<FieldError, TextFieldSheet> _data;

  @override
  void initState() {
    super.initState();
    _valueSubscriber = ObservableSubscriber(_valueListener);
    _dataSubscriber = ObservableSubscriber(_dataListener);
    _subscribe();
  }

  @override
  void didUpdateWidget(TextFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _subscribe();
      _unsubscribe();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _valueSubscriber.subscribe(widget.bone.outValue);
    _dataSubscriber.subscribe(widget.bone.outErrorAndSheet);
  }

  void _unsubscribe() {
    _valueSubscriber.unsubscribe();
    _dataSubscriber.unsubscribe();
  }

  void _valueListener(ObservableState<String> update) {
    _controller.text = update.data;
  }

  void _dataListener(ObservableState<Data2<FieldError, TextFieldSheet>> update) {
    setState(() => _data = update.data);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.bone.inTmpValue,
      focusNode: focusNode,
      decoration: widget.decoration.applyDefaults(Theme.of(context).inputDecorationTheme).copyWith(
            errorText: widget.nosy(_data.data1)?.text,
            errorMaxLines: widget.decoration.errorMaxLines ?? 2,
          ),
      keyboardType: _data.data2.keyboardType,
      obscureText: _data.data2.obscureText,
      maxLength: _data.data2.maxLength,
      inputFormatters: _data.data2.inputFormatters,
      onSubmitted: (_) => nextFocus(),
    );
  }
}

abstract class TextFieldValidator {
  static const List<FieldValidator<String>> base = [
    undefined,
  ];

  static Future<FieldError> undefined(String value) async {
    if (value == null || value.isEmpty) return TextFieldError.undefined;
    return null;
  }
}

class TextFieldError {
  static const undefined = FieldError.$undefined;
  static const invalid = FieldError.$invalid;
}

typedef String _Writer<V>(V value);
typedef V _Reader<V>(String value);

class TextFieldAdapter<V> extends TextFieldSkeleton {
  final List<FieldValidator<V>> adapterValidators;
  final _Writer<V> _writer;
  final _Reader<V> _reader;

  V get adapterValue => _reader(value);
  void inAdapterValue(V value) => inValue(_writer(value));

  TextFieldAdapter(
    this._writer,
    this._reader, {
    int seed,
    List<FieldValidator<V>> adapterValidators,
    List<FieldValidator<String>> textValidators,
    TextFieldSheet sheet: const TextFieldSheet(),
  })  : this.adapterValidators = adapterValidators ?? [],
        super(
          seed: seed?.toString(),
          validators: textValidators,
          sheet: sheet,
        ) {
    this.validators.add((text) async {
      if (this.adapterValidators == null) return null;
      final value = _reader(text);
      for (var validator in this.adapterValidators) {
        final error = await validator(value);
        if (error != null) return error;
      }
      return null;
    });
  }

  static TextFieldAdapter<int> integer({
    TextFieldSheet sheet: const TextFieldSheet(),
    List<FieldValidator<int>> adapterValidators,
    List<FieldValidator<String>> textValidators,
  }) {
    return TextFieldAdapter<int>(
      (int value) {
        return value?.toString();
      },
      (String value) {
        return int.tryParse(value);
      },
      sheet: sheet.copyWith(
        inputFormatters: TextInputFormatters.integer,
        keyboardType: TextInputType.number,
      ),
      adapterValidators: adapterValidators ?? [ValueFieldValidator.undefined],
      textValidators: textValidators,
    );
  }

  static TextFieldAdapter<Rational> price({
    TextFieldSheet sheet: const TextFieldSheet(),
    List<FieldValidator<int>> adapterValidators,
    List<FieldValidator<String>> textValidators,
  }) {
    return TextFieldAdapter<Rational>(
      (Rational value) {
        return value?.toStringAsPrecision(2);
      },
      (String value) {
        return Rational.parse(value.replaceAll(",", "."));
      },
      sheet: sheet.copyWith(
        inputFormatters: TextInputFormatters.price,
        keyboardType: TextInputType.number,
      ),
      adapterValidators: adapterValidators ?? [ValueFieldValidator.undefined],
      textValidators: textValidators,
    );
  }

  static TextFieldAdapter<int> phoneNumber({
    TextFieldSheet sheet: const TextFieldSheet(),
    List<FieldValidator<int>> adapterValidators,
    List<FieldValidator<String>> textValidators,
  }) {
    return TextFieldAdapter<int>(
      (int value) {
        return value?.toString();
      },
      (String value) {
        return int.tryParse(value);
      },
      sheet: sheet.copyWith(
        inputFormatters: TextInputFormatters.phoneNumber,
        keyboardType: TextInputType.phone,
        maxLength: 10,
      ),
      adapterValidators: adapterValidators ?? [ValueFieldValidator.undefined],
      textValidators: textValidators,
    );
  }
}
