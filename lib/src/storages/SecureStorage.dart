import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';


class SecureStorage extends Storage {
  final st = FlutterSecureStorage();

  final String _key;

  SecureStorage({
    @required String key,
    @required VersionManager versionManager,
  }) : this._key = key, assert(key != null), super(versionManager: versionManager);

  SecureStorage.manager({
    @required VersionManager versionManager,
  }) : this(
    key: versionManager.key,
    versionManager: versionManager,
  );

  @override @protected
  Future<String> onGetString({String defaultValue}) async {
    return (await st.read(key: _key))??defaultValue;
  }

  @override @protected
  Future<void> onSetString({@required String value}) async {
    assert(value != null);
    await st.write(key: _key, value: value);
  }
}