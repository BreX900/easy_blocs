import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/foundation.dart';


class CartStorage extends Cart {
  final Storage _storage;

  CartStorage({
    List<ProductCart> products: const [],
    @required Storage storage,
  }) : assert(storage != null),
        this._storage = storage, super(products: products);

  @override
  bool increment(String id) {
    return _store(super.increment(id));
  }

  @override
  bool decrease(String id) {
    return _store(super.decrease(id));
  }

  bool _store(bool save) {
    if (save) {
      _storing();
    }
    return save;
  }

  Future<void> _storing() async {
    await _storage.setMap(map: toJson());
  }

  static Future<CartStorage> load({Storage storage}) async {
    final tmpCart = await storage.getObject(fromJson: Cart.fromJson);
    return CartStorage(products: tmpCart?.products??[], storage: storage);
  }
}



