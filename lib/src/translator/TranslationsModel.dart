import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:json_annotation/json_annotation.dart';


/// Nella classe che contiene questi oggetti deve essere presente @JsonSerializable()
/// con parametri (anyMap: true, explicitToJson: true)
@JsonSerializable(createFactory: false, createToJson: false,)
class Translations extends MapBase<String, String>{
  final HashMap<String, String> _map;

  Translations({String it, String en}) : this._map = HashMap() {
    if (it != null && it.isNotEmpty) _map['it'] = it;
    if (en != null && en.isNotEmpty) _map['en'] = en;
  }

  String get text => translator(_map);

  @override
  String toString() => text;

  @override
  String operator [](Object key) => _map[key];

  @override
  void operator []=(String key, String value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  String remove(Object key) => _map.remove(key);

  Translations.fromJson(HashMap<String, String> map) : this._map = map;
  Map<String, dynamic> toJson() => _map;
}