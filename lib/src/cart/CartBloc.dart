import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


class EasyCartBloc implements Bloc {
  final autoUpdate;

  @protected @override @mustCallSuper
  void dispose() {
    _cartControl.close();
  }

  void init({@required Cart cart}) {
    _cartControl.add(cart);
  }

  CacheSubject<Cart> _cartControl = CacheSubject();
  Stream<Cart> get outCart => _cartControl.stream;

  Future<bool> inIncrement(String id) async {
    return _save(_cartControl.value.increment(id));
  }

  Future<bool> inDecrease(String id) async {
    return _save(_cartControl.value.decrease(id));
  }

  bool _save(bool save) {
    if (autoUpdate && save) {
      _cartControl.add(_cartControl.value);
    }
    return save;
  }

  bool _isEnable = true;

  void inIsEnable(bool isEnable) async {
    _isEnable = isEnable;
    _cartControl.add(_isEnable ? _cartControl.value : null);
  }

  EasyCartBloc.instance({this.autoUpdate: true});
}