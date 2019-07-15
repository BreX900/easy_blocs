import 'dart:async';

import 'package:dash/dash.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';


abstract class PocketBloc implements Bloc {
  final List<PocketSub> _pockets = List();

  PocketSub take(StreamController controller, {
    void onListen(), void onCancel(),
  }) {
    return _pockets.singleWhere((pocket) => pocket._controller == controller,
        orElse: () {
          final pocket = PocketSub(controller);
          _pockets.add(pocket);
          return pocket;
        }
    );
  }
}


class PocketSub<T> {
  final StreamController<T> _controller;
  StreamSubscription _subscription;
  final List<Function> _listeners = [];
  final List<StreamSubscription> _subscriptions = [];

  PocketSub(this._controller, {
    void onListen(), void onCancel(),
  }) {
    _controller.onListen = () {
      if (onListen != null) onListen();
      _listeners.forEach((function) => function());
    };
    _controller.onCancel = () {
      if (onCancel != null) onCancel();
      _subscription?.cancel();
      _subscriptions.forEach((sub) => sub.cancel());
    };
  }

  set addSubscription(StreamSubscription sub) => _subscriptions.add(sub);
  set addListener(void listener()) => _listeners.add(listener);

  void catchSource<E>({
    @required ValueGetter<FutureOr<Stream<E>>> source, @required void onData(E event),
    Function onError, void onDone(), bool cancelOnError: false,
  }) {
    assert(source != null && onData != null);

    addListener = () async {
      final raw = source();
      addSubscription =  (raw is Future ? (await raw) : raw as Stream<E>).listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError,
      );
    };
  }

  void pipeSource(ValueGetter<FutureOr<Stream<T>>> source, {
    Function onError, void onDone(), bool cancelOnError
  }) {
    catchSource<T>(
      source: source,
      onData: _controller.add, onError: onError, onDone: onDone, cancelOnError: cancelOnError,
    );
  }

  void catchStream<E>({
    @required Stream<E> stream, @required void onData(E event),
    Function onError, void onDone(), bool cancelOnError: false,
  }) {
    assert(stream != null && onData != null);
    _subscription?.cancel();
    _subscription = stream.listen(onData,
      onError: onError, onDone: onDone, cancelOnError: cancelOnError,
    );
  }

  void pipeStream(Stream<T> stream, {
    Function onError, void onDone(), bool cancelOnError: false,
  }) {
    catchStream<T>(
      stream: stream, onData: _controller.add,
      onError: onError, onDone: onDone, cancelOnError: cancelOnError,
    );
  }
}