import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


mixin MixinCompositeSubscription<T extends StatefulWidget> on State<T> {
  CompositeSubscription _compositeSubscription;

  @override @mustCallSuper
  void initState() {
    super.initState();
    //print("MixinCompositeSubscription.initState");
    _compositeSubscription = CompositeSubscription();
  }

  @override @mustCallSuper
  void dispose() {
    //print("MixinCompositeSubscription.dispose");
    _compositeSubscription.dispose();
    super.dispose();
  }

  void addSubscription(StreamSubscription subscription) => _compositeSubscription.add(subscription);
  void removeSubscription(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
}
