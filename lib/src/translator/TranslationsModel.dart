import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:json_annotation/json_annotation.dart';





/// Nella classe che contiene questi oggetti deve essere presente @JsonSerializable()
/// con parametri (anyMap: true, explicitToJson: true)
@JsonSerializable(createFactory: false, createToJson: false,)
class TranslationsMap extends MapBase<String, String> implements Translations {
  final Map<String, String> internalMap;

  TranslationsMap({String it, String en}) : this.internalMap = Map(), super() {
    if (it != null && it.isNotEmpty) internalMap[Translations.IT] = it;
    if (en != null && en.isNotEmpty) internalMap[Translations.EN] = en;
  }

  String get text => translator(this);
  @override
  String toString() => this.text;

  @override
  String operator [](Object key) => internalMap[key];

  @override
  void operator []=(String key, String value) => internalMap[key] = value;

  @override
  void clear() => internalMap.clear();

  @override
  Iterable<String> get keys => internalMap.keys;

  @override
  String remove(Object key) => internalMap.remove(key);

  TranslationsMap.fromJson(Map<String, String> map) : this.internalMap = map, super();
  Map<String, dynamic> toJson() => internalMap;
}


@JsonSerializable(createFactory: false, createToJson: false,)
abstract class Translations {
  static const String IT = 'it', EN = 'en';

  const Translations();

  String get text;


  String operator [](String key);
  Iterable<String> get values;

  factory Translations.fromJson(Map<String, String> map) => TranslationsMap.fromJson(map);
  Map<String, dynamic> toJson() => {};
}


@JsonSerializable(createFactory: false, createToJson: false,)
class TranslationsConst extends Translations {
  final String en, it;

  const TranslationsConst({this.it, this.en}) : super();

  String get text => translator(this);
  @override
  String toString() => this.text;

  @override
  String operator [](String key) {
    switch (key) {
      case Translations.EN: return en;
      case Translations.IT: return it;
      default: return null;
    }
  }

  @override
  Iterable<String> get values => [en, it]..removeWhere((value) => value == null);

  static TranslationsMap fromJson(Map<String, String> map) => TranslationsMap.fromJson(map);
  Map<String, dynamic> toJson() => {
    Translations.EN: en,
    Translations.IT: it,
  };
}


/*class CustomDateTimeConverter implements JsonConverter<Translations, String> {
  const CustomDateTimeConverter();

  @override
  CustomDateTime fromJson(String json) =>
      json == null ? null : Translations.fromJson(json);

  @override
  String toJson(CustomDateTime object) => object.toIso8601String();
}*/
