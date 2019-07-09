import 'dart:convert';

import 'package:easy_blocs/src/json.dart';
import 'package:easy_blocs/src/storages/VersionHandler.dart';
import 'package:flutter/cupertino.dart';


abstract class Storage with MixinVersionManager {
  final VersionManager versionManager;

  Storage({
    @required this.versionManager,
  }) : assert(versionManager != null);

  /// Not ovveride this method
  @protected
  Future<String> getString({String defaultValue}) async {
    return versionManager.isCorrectVersion
        ? await onGetString(defaultValue: defaultValue)
        : defaultValue;
  }

  Future<String> onGetString({String defaultValue});

  /// Not ovveride this method
  @protected
  Future<void> setString({@required String value}) async {
    await onSetString(value: value);
    await updateVersion();
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
}