import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'CacheObservable.dart';


/// A special StreamController that captures the latest item that has been
/// added to the controller.
///
/// This subject allows sending data, error and done events to the listener.
/// The latest item that has been added to the subject will be sent to any
/// new listeners of the subject. After that, any new events will be
/// appropriately sent to the listeners. It is possible to provide a seed value
/// that will be emitted if no items have been added to the subject.
///
/// BehaviorSubject is, by default, a broadcast (aka hot) controller, in order
/// to fulfill the Rx Subject contract. This means the Subject's `stream` can
/// be listened to multiple times.
///
/// ### Example
///
///     final subject = new BehaviorSubject<int>();
///
///     subject.add(1);
///     subject.add(2);
///     subject.add(3);
///
///     subject.stream.listen(print); // prints 3
///     subject.stream.listen(print); // prints 3
///
/// ### Example with seed value
///
///     final subject = new BehaviorSubject<int>.seeded(1);
///
///     subject.stream.listen(print); // no prints
///     print(subject.value); // prints 1
class CacheSubject<T> extends Subject<T> implements CacheObservable<T> {
  T latestValue;
  Object latestError;
  StackTrace latestStackTrace;

  bool latestIsValue = false, latestIsError = false;

  CacheSubject._(
      StreamController<T> controller,
      Observable<T> observable,
      this.latestValue,
      ) : super(controller, observable);

  factory CacheSubject({void onListen(), void onCancel(), bool sync = false}) {

    return CacheSubject.seeded(null,
        onListen: onListen,
        onCancel: onCancel,
        sync: sync
    );
  }

  factory CacheSubject.seeded(T value, {void onListen(), void onCancel(), bool sync = false}) {
    // ignore: close_sinks
    final controller = StreamController<T>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );

    return CacheSubject<T>._(
      controller,
      Observable<T>(controller.stream),
      value,
    );
  }



  @override
  void onAdd(T event) {
    latestIsValue = true;
    latestIsError = false;

    latestValue = event;

    latestError = null;
    latestStackTrace = null;
  }

  @override
  void onAddError(Object error, [StackTrace stackTrace]) {
    latestIsValue = false;
    latestIsError = true;

    latestValue = null;

    latestError = error;
    latestStackTrace = stackTrace;
  }

  @override
  CacheObservable<T> get stream => this;

  @override
  bool get hasValue => latestIsValue;

  /// Get the latest value emitted by the Subject
  @override
  T get value => latestValue;

  /// Set and emit the new value
  set value(T newValue) => add(newValue);

  Object get error => latestError;

  StackTrace get stackTrace => latestStackTrace;
}