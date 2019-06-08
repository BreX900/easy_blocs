import 'dart:async';

import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/widgets.dart';


typedef Widget ValueChangedBuilder<V>(BuildContext context, V value);


class CounterProductCart extends StatefulWidget {
  final String id;
  final Stream<Cart> stream;
  final ValueChangedBuilder builder;

  const CounterProductCart({Key key,
    @required this.stream, @required this.id, @required this.builder,
  }) : super(key: key);

  @override
  _CounterProductCartState createState() => _CounterProductCartState();
}

class _CounterProductCartState extends State<CounterProductCart> {
  StreamSubscription _cartSub;
  int _counter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartSub?.cancel();
    _cartSub = widget.stream.listen((cart) {
      _counter = cart == null ? null : cart.getProduct(widget.id)?.numItemsOrdered??0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _counter);
  }
}