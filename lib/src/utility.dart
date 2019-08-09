import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rational/rational.dart';

typedef V ValueToOne<O, V>(O object);

typedef Widget ValueBuilder<V>(BuildContext context, V value);

typedef Widget StateBuilder<S extends State>(S state);

InputDecoration inputDecorationWithHintText(
    InputDecoration decoration, InputDecoration defaultDecoration, Translations hintText,
) {
  if (decoration != null)
    return decoration;
  return decoration.copyWith(
    prefixIcon: decoration.prefixIcon??defaultDecoration.prefixIcon,
    hintText: decoration.hintText??hintText?.text,
  );
}

class RationalJsonKey extends JsonKey {
  const RationalJsonKey() : super(
    fromJson: rationalFromJson, toJson: rationalToJson,
  );

  static Rational rationalFromJson(json) {
    return Rational.fromInt(json as int, 100);
  }
  static final cento = Rational.fromInt(100);
  static int rationalToJson(Rational rational) {
    return (rational*cento).numerator.toInt();
  }
}


class Event<V> {
  final List<V> values;
  Event(this.values);
}
class CompletedEvent<V> extends Event<V> {
  CompletedEvent([List<V> values]) : super(values);
}
class ErrorEvent<V> extends Event<V> {
  ErrorEvent([List<V> values]) : super(values);
}
class CancelEvent<V> extends Event<V> {
  CancelEvent([List<V> values]) : super(values);
}
