import 'dart:async';

import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


mixin MixinStateSubscription<T extends StatefulWidget> on State<T> {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  @override @mustCallSuper
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  void addSubscription(StreamSubscription subscription) => _compositeSubscription.add(subscription);
  void removeSubscription(StreamSubscription subscription) => _compositeSubscription.remove(subscription);
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
