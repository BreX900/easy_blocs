import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:easy_blocs/src/old/CacheSubject.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Usa il controller
@deprecated
class BasicCartBloc implements Bloc {
  @protected
  @override
  @mustCallSuper
  void dispose() {
    _cartControl.close();
  }

  Cart _cart;

  void init({@required Cart cart}) {
    _cart = cart;
    _save(true);
  }

  CacheSubject<Cart> _cartControl = CacheSubject();
  Stream<Cart> get outCart => _cartControl.stream;

  Future<bool> inIncrement(String id) async {
    return _save(_cart.increment(id));
  }

  Future<bool> inDecrease(String id) async {
    return _save(_cart.decrease(id));
  }

  bool _save(bool save) {
    if (save) {
      _cartControl.add(_cart);
    }
    return save;
  }

  void inEnabling(bool isEnable) async {
    _cartControl.add(isEnable ? _cart : null);
  }

  BasicCartBloc.instance();
}
