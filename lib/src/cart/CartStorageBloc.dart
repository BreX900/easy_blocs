import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:easy_blocs/src/storage/utility.dart';
import 'package:flutter/foundation.dart';


class CartStorage extends Cart {
  static const _DEFAULT_FILE_NAME = "CartStorage";
  final String fileName;

  CartStorage(List<ProductCart> products, {this.fileName: _DEFAULT_FILE_NAME,
  }) : assert(fileName != null), super(products);

  @override
  bool increment(String id) {
    return _save(super.increment(id));
  }

  @override
  bool decrease(String id) {
    return _save(super.decrease(id));
  }

  bool _save(bool save) {
    if (save) {
      _store();
    }
    return save;
  }

  Future<File> get _localFile => StorageUtility.getLocalFile(fileName);

  Future<void> _store() async {
    return (await _localFile).writeAsString(jsonEncode(toJson()));
  }

  static Future<CartStorage> load({String fileName: _DEFAULT_FILE_NAME}) async {
    try {
      final file = (await StorageUtility.getLocalFile(fileName));
      if (! await file.exists())
        file.create(recursive: true);
      return CartStorage(Cart.fromJson(
        jsonDecode(await file.readAsString()),
      ).products, fileName: fileName);
    } catch (e) {
      if (!(e is FormatException))
        debugPrint(e);
      return CartStorage([], fileName: fileName);
    }
  }
}



