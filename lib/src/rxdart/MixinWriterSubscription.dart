import 'dart:async';

import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


mixin StateWriterMixin<T extends StatefulWidget> on State<T> {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  @override @mustCallSuper
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  void addSubscription(StreamSubscription subscription) => _compositeSubscription.add(subscription);
  void removeSubscription(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
}

mixin StateSubscriptionMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _subscription;

  set secureSubscription(StreamSubscription subscription) {
    cancelSubscription();
    _subscription = subscription;
  }

  set subscription(StreamSubscription subscription) {
    _subscription = subscription;
  }

  void cancelSubscription() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    cancelSubscription();
    super.dispose();
  }
}

mixin MixinSkeletonSubscription on Skeleton {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  @override @mustCallSuper
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  void addSubscription(StreamSubscription subscription) => _compositeSubscription.add(subscription);
  void removeSubscription(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
}


