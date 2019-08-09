import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreferenceStorage extends Storage {
  final SharedPreferences _pf;

  final String _key;

  PreferenceStorage({
    @required String key,
    SharedPreferences preferences,
    @required VersionManager versionManager,
  }) : this._key = key, this._pf = preferences??RepositoryBlocBase.of().sharedPreferences,
        assert(key != null),
        super(versionManager: versionManager);

  PreferenceStorage.manager(VersionManager versionManager) : this(
    key: '${versionManager.key}#DATA',
    preferences: versionManager.pf,
    versionManager: versionManager,
  );

  @override @protected
  Future<String> onGetString({String defaultValue}) async {
    assert(_pf != null, "Use [VersionHandler.init] method");
    print("P ${_pf.getString(_key)??defaultValue}");
    return _pf.getString(_key)??defaultValue;
  }

  @override @protected
  Future<void> onSetString({@required String value}) async {
    assert(_pf != null, "Use [VersionHandler.init] method");
    await _pf.setString(_key, value);
  }
}