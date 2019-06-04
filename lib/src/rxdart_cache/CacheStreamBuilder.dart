import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheObservable.dart';
import 'package:flutter/widgets.dart';


class CacheStreamBuilder<T> extends StreamBuilderBase<T, AsyncSnapshot<T>> {
  /// Creates a new [StreamBuilder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  ///
  /// The initial snapshot is last data in [CacheObservable]
  ///
  /// The [builder] must not be null.
  CacheStreamBuilder({
    Key key,
    @required CacheObservable<T> stream,
    @required this.builder,
  }) : assert(stream is CacheObservable, "The [StreamController] must is [CacheSubject]"), assert(builder != null),
        super(key: key, stream: stream);

  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<T> builder;

  @override
  AsyncSnapshot<T> initial() {
    final observable = stream as CacheObservable<T>;
    return observable.latestIsError ?
    AsyncSnapshot<T>.withError(ConnectionState.none, observable.error) :
    AsyncSnapshot<T>.withData(ConnectionState.none, observable.value);
  }

  @override
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) => current.inState(ConnectionState.waiting);

  @override
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  @override
  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error) {
    return AsyncSnapshot<T>.withError(ConnectionState.active, error);
  }

  @override
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) => current.inState(ConnectionState.done);

  @override
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) => current.inState(ConnectionState.none);

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) => builder(context, currentSummary);
}