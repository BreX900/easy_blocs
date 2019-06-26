import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class Controller {
  void close();

  static C catchStream<C extends StreamController<V>, V>({
    @required C controller, @required Function source,
    void onListen(V value), void onCancel(), bool sync = false,
  }) {
    StreamSubscription<V> subscription;
    V value;

    controller.onListen = () async {
      final stream = source();
      subscription = (stream is Future ? await stream : stream).listen((_value) => controller.add(value = _value),
        onError: (error) => print("....$error"),
      );
      if (onListen != null) onListen(value);
      else controller.add(value);
    };
    controller.onCancel = () {
      subscription.cancel();
      if (onCancel != null) onCancel();
    };
    return controller;
  }
}


abstract class PublishController {
  static PublishSubject<V> asyncCatchStream<V>({
    @required Future<Stream<V>> source(),
    void onListen(V value), void onCancel(), bool sync = false,
  }) {
    PublishSubject<V> controller;
    StreamSubscription<V> subscription;
    V value;

    controller = PublishSubject<V>(
      onListen: () async {
        subscription = (await source()).listen((_value) => controller.add(value = _value),
          onError: (error) => print("....$error"),
        );
        if (onListen != null) onListen(value);
        else controller.add(value);
      },
      onCancel: () {
        subscription.cancel();
        if (onCancel != null) onCancel();
      },
      sync: sync,
    );
    return controller;
  }

  static PublishSubject<V> catchStream<V>({
    @required Stream<V> source,
    void onListen(V value), void onCancel(), bool sync = false,
  }) {
    return asyncCatchStream<V>(source:() async => source,
        onListen: onListen, onCancel: onCancel, sync: sync);
  }
}


abstract class BehaviorController {
  static BehaviorSubject<V> asyncCatchStream<V>({
    @required Future<Stream<V>> source(),
    void onListen(V value), void onCancel(), bool sync = false,
  }) {
    BehaviorSubject<V> controller;
    StreamSubscription<V> subscription;
    V value;

    controller = BehaviorSubject<V>(
      onListen: () async {
        subscription = (await source()).listen((_value) {
          controller.add(value = _value);
        },
          onError: (error) => print("....$error"),
        );
        if (onListen != null) onListen(value);
        else controller.add(value);
      },
      onCancel: () {
        subscription.cancel();
        if (onCancel != null) onCancel();
      },
      sync: sync,
    );
    return controller;
  }

  static BehaviorSubject<V> catchStream<V>({
    @required Stream<V> source,
    void onListen(V value), void onCancel(), bool sync = false,
  }) {
    return asyncCatchStream<V>(source:() async => source,
        onListen: onListen, onCancel: onCancel, sync: sync);
  }
}

