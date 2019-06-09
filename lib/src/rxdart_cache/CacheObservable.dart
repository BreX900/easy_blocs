import 'dart:async';

import 'package:rxdart/rxdart.dart';


/// An [Observable] that provides synchronous access to the last emitted item
class CacheObservable<T> extends Observable<T> {
  /// Last emitted value, or null if there has been no emission yet
  /// See [hasValue]
  /// Get the latest value emitted by the Subject

  T latestValue;
  Object latestError;
  StackTrace latestStackTrace;

  bool latestIsValue = false, latestIsError = false;

  CacheObservable(Stream<T> stream) : super(stream);

  T get value => latestValue;

  bool get hasValue => latestIsValue;

  Object get error => latestError;
  StackTrace get stackTrace => latestStackTrace;

  @override
  StreamSubscription<T> listen(void onData(T event),
      {Function onError, void onDone(), bool cancelOnError, initialData: false}) {
    if (!initialData) latestIsError ? onError(error) : onData(value);
    return super.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}