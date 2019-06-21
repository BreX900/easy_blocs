import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreferenceStorage extends StorageRule {
  final SharedPreferences pf;

  final String _key;

  PreferenceStorage({
    @required String key, String version: "beta-0",
    SharedPreferences sharedPreferences,
  }) : this._key = key, this.pf = sharedPreferences??RepositoryBloc.of().sharedPreferences,
        super(key: key, version: version,
      sharedPreferences: sharedPreferences,
    );

  Future<String> getString({String defaultValue}) async {
    assert(pf != null, "Use [VersionHandler.init] method");
    return isCorrectVersion
        ?  pf.getString(_key)??defaultValue
        : defaultValue;
  }

  Future<void> setString({@required String value}) async {
    assert(pf != null, "Use [VersionHandler.init] method");
    super.setString(value: value);
    await pf.setString(_key, value);
  }
}