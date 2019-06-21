import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';


class SecureStorage extends StorageRule {
  final st = FlutterSecureStorage();

  final String _key;

  SecureStorage({
    @required String key, String version: "beta-0",
  }) : this._key = key, super(key: key, version: version);

  Future<String> getString({String defaultValue}) async {
    return isCorrectVersion
        ? (await st.read(key: _key))??defaultValue
        : defaultValue;
  }

  Future<void> setString({@required String value}) async {
    assert(value != null);
    await super.setString(value: value);
    await st.write(key: _key, value: value);
  }
}