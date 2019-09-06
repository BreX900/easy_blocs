import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

mixin SubscribersStateMixin<T extends StatefulWidget> on State<T> {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  @override
  @mustCallSuper
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  @protected
  set subscribe(StreamSubscription subscription) => _compositeSubscription.add(subscription);
  @protected
  set unsubscribe(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
}

mixin SubscribeStateMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _subscription;

  set subscribe(StreamSubscription subscription) {
    unsubscribe();
    _subscription = subscription;
  }

  void unsubscribe() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }
}

//mixin MixinSkeletonSubscription on Skeleton {
//  final CompositeSubscription _compositeSubscription = CompositeSubscription();
//
//  @override @mustCallSuper
//  void dispose() {
//    _compositeSubscription.dispose();
//    super.dispose();
//  }
//
//  void addSubscription(StreamSubscription subscription) => _compositeSubscription.add(subscription);
//  void removeSubscription(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
//}
