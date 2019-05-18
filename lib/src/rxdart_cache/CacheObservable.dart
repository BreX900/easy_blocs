import 'package:rxdart/rxdart.dart';


/// An [Observable] that provides synchronous access to the last emitted item
abstract class CacheObservable<T> implements Observable<T> {
  /// Last emitted value, or null if there has been no emission yet
  /// See [hasValue]
  T get value;

  bool get hasValue;

  Object get error;
  StackTrace get stackTrace;

  bool latestIsValue = false, latestIsError = false;
}