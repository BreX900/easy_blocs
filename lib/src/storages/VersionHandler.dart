import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionHandler {
  final SharedPreferences pf;

  final String _key;

  final String version;

  VersionHandler(this._key, this.version, {
    SharedPreferences sharedPreferences,
  }) : this.pf = sharedPreferences??RepositoryBloc.of().sharedPreferences;

  VersionHandler.generateKey(String key, String version, {
    SharedPreferences sharedPreferences,
  }) : this(key+"#Version", version, sharedPreferences: sharedPreferences);

  bool get isCorrectVersion => pf.getString(_key) == version;

  Future<bool> updateVersion() async {
    if (pf.getString(_key) != version) {
      return await pf.setString(_key, version);
    }
    return false;
  }
}


mixin MixinVersionHandler {
  VersionHandler get versionHandler;

  String get version => versionHandler.version;

  bool get isCorrectVersion => versionHandler.isCorrectVersion;

  Future<bool> updateVersion() {
    return versionHandler.updateVersion();
  }
}