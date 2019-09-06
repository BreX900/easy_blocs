import 'package:easy_blocs/src/old/CacheStreamBuilder.dart';
import 'package:easy_blocs/src/old/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/material.dart';


class CheckerField<V> extends CacheStreamBuilder<DataField<V>> {
  CheckerField({Key key,
    @required CheckerRule<V, String> checker, Translator translator,
    InputDecoration decoration: const InputDecoration(),
  }) : super(
    key: key,
    stream: checker.outData,
    builder: (context, snap) {

      final data = snap.data;

      return TextFormField(
        initialValue: data.text,
        focusNode: checker.focusNode,
        decoration: decoration.copyWith(
          errorText: translator(snap.data.error)?.text,
          errorMaxLines: decoration.errorMaxLines??2,
        ),
        keyboardType: checker.keyboardType,
        obscureText: data.obscureText,

        maxLength: checker.maxLength,

        onFieldSubmitted: (_) => checker.nextFinger(context),
        onSaved: checker.onSaved, //(value) => checker.add(data.copyWith(value: onSaved(value))),//(text) => checker.add(data.copyWith(text: text)),
        validator: (value) => translator(checker.validate(value))?.text,
        inputFormatters: checker.inputFormatters,
      );
    },
  );
}