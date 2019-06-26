import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';


class CartController implements CartControllerRule{
  final Cart _cart;

  CartController({Cart cart: const Cart(), void onListen()}) : assert(cart!=null), this._cart = cart {
    _cartController = PublishSubject(onListen: () {
      _cartController.add(_cart);
      if (onListen != null) onListen();
    });
  }
  CartController.storage({
    Cart cart: const Cart(), @required Storage storage,
    void onListen(),
  }) : assert(cart!=null), this._cart = cart {
    _cartController = PublishSubject(onListen: () async {
      _cartController.add(await CartStorage.load(
        storage: storage,
      ));
      if (onListen != null) onListen();
    });
  }

  void close() {
    _cartController.close();
  }

  PublishSubject<Cart> _cartController;
  Observable<Cart> get outCart => _cartController.stream;

  void add(Cart cart) {
    _cartController.add(cart);
  }

  Future<bool> inIncrement(String id) async {
    return _update(_cart.increment(id));
  }

  Future<bool> inDecrease(String id) async {
    return _update(_cart.decrease(id));
  }

  bool _update(bool update) {
    if (update)
      _cartController.add(_cart);
    return update;
  }
}


abstract class CartControllerRule {

  Observable<Cart> get outCart;

  Future<void> inIncrement(String id);

  Future<void> inDecrease(String id);
}


mixin MixinCartController implements CartControllerRule {
  CartControllerRule get cartController;

  Observable<Cart> get outCart => cartController.outCart;

  Future<void> inIncrement(String id) => cartController.inIncrement(id);

  Future<void> inDecrease(String id) => cartController.inDecrease(id);
}

/// Vedi [CartStorage]
/*class StorageCartController extends CartController {
  final Storage storage;

  StorageCartController({
    Cart tmpCart, @required this.storage,
  }) : assert(storage != null), super(cart: tmpCart??[]) {
    storage.getObject(fromJson: Cart.fromJson, ).then((cart) {
      _cartController.add(cart);
    });
  }


  Future<bool> inIncrement(String id) async {
    return await _storage(await super.inIncrement(id));
  }

  Future<bool> inDecrease(String id) async {
    return await _storage(await super.inDecrease(id));
  }

  Future<bool> _storage(bool update) async {
    if (update) {
      storage.setMap(map: _cart.toJson());
    }
    return update;
  }
}*/