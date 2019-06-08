import 'dart:async';
import 'dart:convert';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartStorage extends Cart {
  static const _KEY = "CartStorage";

  CartStorage(List<ProductCart> products) : super(products);

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
    await (await SharedPreferences.getInstance()).setString(_KEY, jsonEncode(toJson()));
  }

  static Future<CartStorage> load() async {
    return CartStorage(Cart.fromJson(
      jsonDecode((await SharedPreferences.getInstance()).getString(_KEY)),
    ).products);
  }
}



