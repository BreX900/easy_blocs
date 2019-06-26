import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionManager {
  final SharedPreferences pf;

  final String key;

  final String version;

  VersionManager(String key, {
    this.version: "beta-0",
    SharedPreferences sharedPreferences,
  }) : this.key = '$key#Version', this.pf = sharedPreferences??RepositoryBloc.of().sharedPreferences,
      assert(key != null), assert(version != null);

  bool get isCorrectVersion => pf.getString(key) == version;

  Future<bool> updateVersion() async {
    if (pf.getString(key) != version) {
      return await pf.setString(key, version);
    }
    return false;
  }
}


mixin MixinVersionManager {
  VersionManager get versionManager;

  String get version => versionManager.version;

  bool get isCorrectVersion => versionManager.isCorrectVersion;

  Future<bool> updateVersion() {
    return versionManager.updateVersion();
  }
}