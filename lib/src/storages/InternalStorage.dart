import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/storages/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


class InternalStorage extends Storage {
  final String _key;

  InternalStorage({
    @required String key,
    @required VersionManager versionManager,
  }) : this._key = key, assert(key != null), super(versionManager: versionManager);

  InternalStorage.manager({
    @required VersionManager versionManager,
  }) : this(
    key: versionManager.key,
    versionManager: versionManager,
  );

  File _file;

  Future<File> _getFile() async {
    if (_file == null)
      _file = await StorageUtility.getLocalFile(_key);
    return _file;
  }

  @override @protected
  Future<String> onGetString({String defaultValue}) async {
    try {
      return await (await _getFile()).readAsString();
    } catch(error) {
      return defaultValue;
    }
  }

  @override @protected
  Future<void> onSetString({String value}) async {
    assert(value != null);
    final file = await _getFile();
    if (! await file.exists()) {
      await file.create(recursive: true);
    }
    return await file.writeAsString(value);
  }
}