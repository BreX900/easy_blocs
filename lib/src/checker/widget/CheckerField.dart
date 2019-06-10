import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:flutter/material.dart';


class CheckerField<V, E> extends StatelessWidget {
  final CheckerRule<E> checker;
  final Translator<E> translator;
  final InputDecoration decoration;

  const CheckerField({Key key,
    @required this.checker, @required this.translator,
    this.decoration: const InputDecoration(),
  }) :
        assert(checker != null), assert(translator != null),
        assert(decoration != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder<DataField>(
      stream: checker.outData,
      builder: (context, snap) {
        final data = snap.data;
        return TextFormField(
          initialValue: data.text,
          focusNode: checker.focusNode,
          decoration: decoration.copyWith(
            errorText: snap.error is E ? '${snap.error}' : null,
          ),

          obscureText: data.obscureText,

          maxLength: checker.maxLength,

          onFieldSubmitted: (_) => checker.nextFinger(context),
          onSaved: (text) => checker.add(data.copyWith(text: text)),
          validator: (value) => translator(checker.validate(value))?.text,
          inputFormatters: checker.inputFormatters,
        );
      },
    );
  }
}