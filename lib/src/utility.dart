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


typedef Future<Res> ReqToRes(Req req);


abstract class Req { const Req(); }
abstract class Res { const Res(); }
abstract class Event { const Event(); }
abstract class ReqResEvent implements Req, Res, Event { const ReqResEvent(); }
class EventValue<V> {
  final List<V> values;
  EventValue(this.values);
}
class CompletedEvent<V> extends EventValue<V> {
  CompletedEvent([List<V> values]) : super(values);
}
class ErrorEvent<V> extends EventValue<V> {
  ErrorEvent([List<V> values]) : super(values);
}
class CancelEvent<V> extends EventValue<V> {
  CancelEvent([List<V> values]) : super(values);
}
