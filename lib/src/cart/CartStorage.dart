import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/foundation.dart';


class CartStorage extends Cart {
  final StorageRule _storage;

  CartStorage(List<ProductCart> products, {
    @required StorageRule storage,
  }) : assert(storage != null),
        this._storage = storage, super(products);

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

  Future<void> _store() async {
    await _storage.setMap(map: toJson());
  }

  static Future<CartStorage> load({String fileName: "CartStorage", String version: 'beta-0'}) async {
    final storage = InternalStorage(key: fileName, version: version);

    final tmpCart = await storage.getObject(fromJson: Cart.fromJson, );

    return CartStorage(tmpCart?.products??[], storage: storage);
  }
}



