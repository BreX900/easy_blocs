import 'dart:convert';

import 'package:easy_blocs/src/json.dart';
import 'package:easy_blocs/src/storages/VersionHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class StorageRule with MixinVersionHandler {
  final VersionHandler versionHandler;

  StorageRule({
    @required String key, @required String version,
    SharedPreferences sharedPreferences,
  }) : assert(key != null), assert(version != null),
        this.versionHandler = VersionHandler.generateKey(key, version,
          sharedPreferences: sharedPreferences,
        );

  Future<String> getString({String defaultValue});

  @mustCallSuper
  Future<void> setString({@required String value}) async {
    await updateVersion();
  }

  Future<Map<String, dynamic>> getMap({Map<String, dynamic> defaultValue}) async {
    return jsonDecode((await getString())??defaultValue);
  }

  @mustCallSuper
  Future<void> setMap({@required Map<String, dynamic> map}) async {
    await updateVersion();
    await setString(value: jsonEncode(map));
  }

  Future<T> getObject<T>({@required T fromJson(Map<String, dynamic> map), T defaultValue}) async {
    return fromJson((await getMap())??defaultValue);
  }

  @mustCallSuper
  Future<void> setObject({@required JsonRule object}) async {
    await updateVersion();
    await setMap(map: object.toJson());
  }
}