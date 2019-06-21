import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:meta/meta.dart';


class InternalStorage extends StorageRule {
  final String _key;

  InternalStorage({
    @required String key, String version: 'beta-0',
  }) : this._key = key, super(key: key, version: version);

  File _file;

  Future<File> _getFile() async {
    if (_file == null)
      _file = await StorageUtility.getLocalFile(_key);
    return _file;
  }

  @override
  Future<String> getString({String defaultValue}) async {
    try {
      return await (await _getFile()).readAsString();
    } catch(error) {
      return defaultValue;
    }
  }

  @override
  Future<void> setString({String value}) async {
    assert(value != null);
    super.setString(value: value);
    final file = await _getFile();
    if (! await file.exists()) {
      await file.create(recursive: true);
    }
    return await file.writeAsString(value);
  }
}