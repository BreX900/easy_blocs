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





/*class PocketStream<V> {
  final HashMap<String, StreamSubscription> _signedListeners = HashMap();

  void onCancel() {
    _signedListeners.values.forEach((sub) => sub.cancel());
  }

  void operator []=(String key, StreamSubscription value) => _signedListeners[key] = value;

  void catchStream<C, E>(StreamController<C> controller, String tag, Stream<E> stream, {
    @required void onData(E event), Function onError, void onDone(), bool cancelOnError: false,
  }) {
    assert(tag != null && stream != null && onData != null);
    _signedListeners[tag]?.cancel();
    _signedListeners[tag] = stream.listen(onData,
      onError: onError, onDone: onDone, cancelOnError: cancelOnError,
    );
  }

  void addStream<V>(StreamController<V> controller, String tag, Stream<V> stream, {
    Function onError, void onDone(), bool cancelOnError
  }) {
    catchStream<V, V>(
      controller, tag, stream,
      onData: controller.add, onError: onError, onDone: onDone, cancelOnError: cancelOnError,
    );
  }
}*/


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

