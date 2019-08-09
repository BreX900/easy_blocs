//import 'dart:async';
//
//import 'package:easy_blocs/src/tree/ScrollViews.dart';
//import 'package:flutter/widgets.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//mixin BranchWriterMixin on StatelessBranch {
//  final CompositeSubscription _subscriptions = CompositeSubscription();
//
//  @override
//  void disposeBranch(BuildContext context) {
//    _subscriptions.dispose();
//    super.disposeBranch(context);
//  }
//
//  void addSubscription(StreamSubscription subscription) => _subscriptions.add(subscription);
//  void removeSubscription(StreamSubscription subscription) => _subscriptions.remove(subscription);
//}
//
//
//mixin BranchSubscriptionMixin on StatefulBranch {
//  StreamSubscription _subscription;
//
//  void addSubscription(StreamSubscription subscription) {
//    _subscription?.cancel();
//    _subscription = subscription;
//  }
//
//  void cancelSubscription() {
//    _subscription?.cancel();
//  }
//
//  @override
//  void disposeBranch(BuildContext context) {
//    cancelSubscription();
//    super.disposeBranch(context);
//  }
//}
