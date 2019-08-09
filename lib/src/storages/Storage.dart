import 'dart:convert';

import 'package:easy_blocs/src/json.dart';
import 'package:easy_blocs/src/storages/VersionHandler.dart';
import 'package:flutter/cupertino.dart';


abstract class Storage with MixinVersionManager {
  final VersionManager versionManager;
  String _cache;
  bool _isInCache = false;

  Storage({
    @required this.versionManager,
  }) : assert(versionManager != null);

  /// Not ovveride this method
  @protected
  Future<String> getString({String defaultValue}) async {
    if (!_isInCache) {
      _cache = versionManager.isCorrectVersion
          ? await onGetString(defaultValue: defaultValue)
          : defaultValue;
      _isInCache = true;
    }
    return _cache;
  }

  Future<String> onGetString({String defaultValue});

  /// Not ovveride this method
  @protected
  Future<void> setString({@required String value}) async {
    if (!_isInCache || (_isInCache && _cache != value)) {
      _isInCache = false;
      await onSetString(value: value);
      await updateVersion();
    }
  }
  Future<void> onSetString({@required String value});

  Future<Map<String, dynamic>> getMap({Map<String, dynamic> defaultValue}) async {
    final raw = await getString();
    return raw == null ? defaultValue : jsonDecode(raw);
  }

  @mustCallSuper
  Future<void> setMap({@required Map<String, dynamic> map}) async {
    await updateVersion();
    await setString(value: jsonEncode(map));
  }

  Future<T> getObject<T>({@required T fromJson(Map<String, dynamic> map), T defaultValue}) async {
    final raw = await getMap();
    return raw == null ? defaultValue : fromJson(raw);
  }

  @mustCallSuper
  Future<void> setObject({@required JsonRule object}) async {
    await updateVersion();
    await setMap(map: object.toJson());
  }

  Future<E> getEnum<E>({@required Iterable<E> enumValues, E defaultValue}) async {
    final raw = await getString();
    return raw == null ? defaultValue : enumValues.firstWhere((value) => value.toString() == raw,
      orElse: () => defaultValue);
  }

  @mustCallSuper
  Future<void> setEnum({@required Object enumValue}) async {
    await updateVersion();
    await setString(value: enumValue?.toString());
  }
}