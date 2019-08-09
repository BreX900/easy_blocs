import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:json_annotation/json_annotation.dart';





/// Nella classe che contiene questi oggetti deve essere presente @JsonSerializable()
/// con parametri (anyMap: true, explicitToJson: true)
@JsonSerializable(createFactory: false, createToJson: false,)
class TranslationsMap extends Translations with MapMixin<String, String> {
  final Map<String, String> _translations;

  TranslationsMap({String it, String en}) : this._translations = Map(), super() {
    if (it != null && it.isNotEmpty) _translations[Translations.IT] = it;
    if (en != null && en.isNotEmpty) _translations[Translations.EN] = en;
  }

  TranslationsMap.map(this._translations);

  @override
  String operator [](Object key) => _translations[key];

  @override
  void operator []=(String key, String value) => _translations[key] = value;

  @override
  void clear() => _translations.clear();

  @override
  Iterable<String> get keys => _translations.keys;

  @override
  String remove(Object key) => _translations.remove(key);

  @override
  String toString() => this.text;

  TranslationsMap.fromJson(Map<String, String> map) : this._translations = map, super();
  Map<String, dynamic> toJson() => _translations;
}


@JsonSerializable(createFactory: false, createToJson: false,)
abstract class Translations {
  static const String IT = 'it', EN = 'en';

  const Translations();

  String get text => translator(this);
  @override
  String toString() => this.text;

  bool get isEmpty;

  bool get isUndefined => isEmpty || !values.any((value) => value != null && value.trim().isNotEmpty);

  String operator [](String key);
  Iterable<String> get values;

  factory Translations.fromJson(Map<String, String> map) => TranslationsMap.fromJson(map);
  Map<String, dynamic> toJson() => {};
}


@JsonSerializable(createFactory: false, createToJson: false,)
class TranslationsConst extends Translations  {
  final String en, it;

  const TranslationsConst({this.it, this.en});

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
  @override
  bool get isEmpty => values.length < 1;

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
