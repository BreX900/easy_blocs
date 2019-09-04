import 'dart:async';
import 'dart:collection';

import 'package:easy_blocs/src/utility.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef bool ObservableComparator<V>(ObservableState<V> bef, ObservableState<V> aft);

class ObservableSubscriber<V> {
  final ValueChanged<ObservableState<V>> onChanged;

  StreamSubscription<V> _subscription;
  ObservableState<V> _state;

  set _setState(ObservableState<V> state) {
    _state = state;
    onChanged(_state);
  }

  ObservableSubscriber(this.onChanged);

  void subscribe(Stream<V> stream,
      {V initialData, ObservableComparator<V> comparator: dataComparator}) {
    assert(stream != null && comparator != null);
    _subscription = stream.listen((V data) {
      final newUpdate = ActiveState<V>(data: data);
      if (!comparator(_state, newUpdate)) _setState = newUpdate;
    }, onError: (Object error) {
      final newUpdate = ErrorState<V>(error: error);
      if (!comparator(_state, newUpdate)) _setState = newUpdate;
    }, onDone: () {
      _setState = DoneState<V>(data: _state.data, error: _state.error);
    });
    _setState = WaitingState<V>(
        data: stream is ValueObservable<V> ? stream.value ?? initialData : initialData);
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  static bool dataComparator(ObservableState bef, ObservableState aft) {
    return bef.data == aft.data;
  }

  static bool passComparator(ObservableState bef, ObservableState aft) {
    return false;
  }

  static bool dataAndStateComparator(ObservableState bef, ObservableState aft) {
    return bef.data == aft.data && bef.runtimeType == aft.runtimeType;
  }
}

abstract class ObservableListener<V> implements StatefulWidget {
  Stream<V> get stream;
}

mixin ObservableListenerStateMixin<WidgetType extends ObservableListener<V>, V>
    on State<WidgetType> {
  ObservableSubscriber<V> _subscriber;

  final V initialData = null;
  ObservableComparator<V> get comparator => ObservableSubscriber.dataComparator;

  @override
  void initState() {
    super.initState();
    _subscriber = ObservableSubscriber<V>(onChangeObservableState);
    _subscribe();
  }

  @override
  void didUpdateWidget(WidgetType oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      _subscriber.unsubscribe();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscriber.unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscriber.subscribe(widget.stream, initialData: initialData, comparator: comparator);
  }

  void onChangeObservableState(ObservableState<V> state);
}

typedef Widget ObservableStateBuilder<V>(BuildContext context, ObservableState<V> state);
typedef Widget ObservableValueBuilder<V>(BuildContext context, V value, ObservableState<V> state);

class ObservableBuilder<V> extends StatefulWidget implements ObservableListener<V> {
  ObservableBuilder({
    Key key,
    this.initialData,
    @required this.stream,
    @required this.builder,
    this.comparator: ObservableSubscriber.dataComparator,
  })  : assert(builder != null),
        assert(stream != null),
        super(key: key);

  final ObservableValueBuilder<V> builder;

  final V initialData;

  final Stream<V> stream;

  final ObservableComparator<V> comparator;

  @override
  _ObservableBuilderState<V> createState() => _ObservableBuilderState<V>();
}

class _ObservableBuilderState<V> extends State<ObservableBuilder<V>>
    with ObservableListenerStateMixin<ObservableBuilder<V>, V> {
  ObservableState<V> _state;

  @override
  V get initialData => widget.initialData;
  @override
  ObservableComparator<V> get comparator => widget.comparator;

  @override
  void onChangeObservableState(ObservableState<V> state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state.data, _state);
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
class _InfoItemBuilder {
  final int length, index;

  _InfoItemBuilder(this.length, this.index);

  bool get isDangerZone => index >= length;
  bool get isSafeZone => index < length;
}

typedef Widget _ListObservableBuilder<V>(
  BuildContext context,
  IndexedWidgetBuilder itemBuilder,
  ObservableState<List<V>> state,
);
typedef IndexedWidgetBuilder _ItemObservableBuilder<V>(
    Widget builder(int index, ValueObservable<V> outValue));

typedef Widget _AdvListObservableBuilder<V>(
  BuildContext context,
  _AdvItemObservableBuilder<V> itemBuilder,
  ObservableState<List<V>> state,
);
typedef IndexedWidgetBuilder _AdvItemObservableBuilder<V>(
    Widget builder(BuildContext context, V value));

typedef Widget _ItemBuilder<V>(BuildContext context, Stream<V> stream, _InfoItemBuilder info);

class ObservableListBuilder<V> extends StatefulWidget {
  final Stream<List<V>> stream;

  final _ListObservableBuilder<V> builder;
  final _ItemBuilder<V> itemBuilder;

  const ObservableListBuilder.basic({
    Key key,
    @required this.stream,
    @required this.builder,
    @required this.itemBuilder,
  }) : super(key: key);

  ObservableListBuilder({
    Key key,
    @required this.stream,
    @required this.builder,
    @required Widget itemBuilder(BuildContext context, V value, _InfoItemBuilder info),
  })  : this.itemBuilder = ((_, outValue, info) {
          return ObservableBuilder(
            stream: outValue,
            builder: (context, value, _) {
              return itemBuilder(context, value, info);
            },
          );
        }),
        super(key: key);

  @override
  _ObservableListBuilderState<V> createState() => _ObservableListBuilderState<V>();
}

class _ObservableListBuilderState<V> extends State<ObservableListBuilder<V>> {
  ObservableSubscriber<List<V>> _subscriber;

  Stream<List<V>> _distinctStream;

  ObservableState<List<V>> _state;

  @override
  void initState() {
    super.initState();
    _subscriber = ObservableSubscriber(_listListener);
    _initListeners();
  }

  @override
  void didUpdateWidget(ObservableListBuilder<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      _subscriber.unsubscribe();
      _initListeners();
    }
  }

  @override
  void dispose() {
    _subscriber.unsubscribe();
    super.dispose();
  }

  void _initListeners() {
    _subscriber.subscribe(widget.stream, comparator: (bef, aft) {
      return bef.data?.length == aft.data.length;
    });
    _distinctStream = widget.stream.distinct((bef, aft) {
      return bef?.length != aft?.length;
    });
  }

  void _listListener(ObservableState<List<V>> state) {
    setState(() => _state = state);
  }

  ValueObservable<V> _getItemStream(int index) {
    return Observable(_distinctStream.map((items) => items[index]))
        .shareValueSeeded(_state.data[index]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, (context, index) {
      final info = _InfoItemBuilder(_state.data.length, index);
      if (info.isDangerZone)
        return widget.itemBuilder(context, null, info);
      return widget.itemBuilder(
          context, _getItemStream(index), info);
    }, _state);
  }
}

abstract class ObservableState<D> {
  final D data;
  final Object error;

  const ObservableState({this.data, this.error});

  bool get hasData => data != null;
  bool get hasNoData => data == null;
  bool get hasError => error != null;
  bool get hasNoError => error == null;

  bool get hasValues => hasData || hasError;
  bool get hasNoValues => hasNoData && hasNoError;

  bool get isBadState => hasError || hasNoData;

  Widget toWidget();
  Widget toSliver();

  @override
  String toString() => "ObservableState()";
}

class WaitingState<D> extends ObservableState<D> with _WaitingWidgets {
  const WaitingState({D data, Object error}) : super(data: data, error: error);
  @override
  Widget toWidget() => toWaitWidget();
  @override
  Widget toSliver() => toWaitSliver();
  @override
  String toString() => "WaitingState()";
}

class ActiveState<D> extends ObservableState<D> with _WaitingWidgets, _ErrorWidgets {
  const ActiveState({D data, Object error}) : super(data: data, error: error);
  @override
  Widget toWidget() => hasError ? toErrorWidget() : toWaitWidget();
  @override
  Widget toSliver() => hasError ? toErrorSliver() : toWaitSliver();
  @override
  String toString() => "ActiveState()";
}

class DoneState<D> extends ObservableState<D> with _WaitingWidgets, _ErrorWidgets {
  const DoneState({D data, Object error}) : super(data: data, error: error);
  @override
  Widget toWidget() => hasError ? toErrorWidget() : toWaitWidget();
  @override
  Widget toSliver() => hasError ? toErrorSliver() : toWaitSliver();
  @override
  String toString() => "DoneState()";
}

class ErrorState<D> extends ObservableState<D> with _ErrorWidgets {
  const ErrorState({D data, Object error}) : super(data: data, error: error);
  @override
  Widget toWidget() => toErrorWidget();
  @override
  Widget toSliver() => toErrorSliver();
  @override
  String toString() => "DoneState()";
}

mixin _WaitingWidgets<D> on ObservableState<D> {
  Widget toWaitWidget() {
    return const Center(
      child: const Padding(
        padding: const EdgeInsets.all(8.0),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget toWaitSliver() {
    return const SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: const SliverToBoxAdapter(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

mixin _ErrorWidgets<D> on ObservableState<D> {
  Widget toErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("!!! ERROR !!!\n$error"),
      ),
    );
  }

  Widget toErrorSliver() {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverToBoxAdapter(
        child: Text("!!! ERROR !!!\n$error"),
      ),
    );
  }
}

abstract class ObservableCombiner {
  static ValueObservable<T> latest2<A, B, T>(
      ValueObservable<A> streamA, ValueObservable<B> streamB, T combiner(A valueA, B valueB)) {
    return Observable.combineLatest2(streamA, streamB, combiner)
        .shareValueSeeded(combiner(streamA.value, streamB.value));
  }
}

//abstract class Controller {
//  void close();
//
//  static C catchStream<C extends StreamController<V>, V>({
//    @required C controller, @required Function source,
//    void onListen(V value), void onCancel(), bool sync = false,
//  }) {
//    StreamSubscription<V> subscription;
//    V value;
//
//    controller.onListen = () async {
//      final stream = source();
//      subscription = (stream is Future ? await stream : stream).listen((_value) => controller.add(value = _value),
//        onError: (error) => print("....$error"),
//      );
//      if (onListen != null) onListen(value);
//      else controller.add(value);
//    };
//    controller.onCancel = () {
//      subscription.cancel();
//      if (onCancel != null) onCancel();
//    };
//    return controller;
//  }
//}

//typedef Widget _BoneBuilder<B extends Bone, V>(
//    BuildContext context, B bone, V value, ObservableState state);
//typedef Stream<V> _Strimmer<B extends Bone, V>(BuildContext context, B bone);
//
//class BoneBuilder<B extends Bone, V> extends StatefulWidget {
//
//  BoneBuilder(this.builder, {
//    Key key,
//    this.initialData,
//    @required this.outer,
//    this.forceUpdate: false,
//  }) : assert(builder != null),
//        assert(outer != null),
//        super(key: key);
//
//  final _BoneBuilder<B, V> builder;
//
//  final V initialData;
//
//  final _Strimmer<B, V> outer;
//
//  final forceUpdate;
//
//  @override
//  BoneBuilderState<B, V> createState() => BoneBuilderState<B, V>();
//}
//
//class BoneBuilderState<B extends Bone, V> extends State<BoneBuilder<B, V>> with _Subscriber {
//  B _bone;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    final newBone = BoneProvider.of<B>(context, false);
//
//    if (_bone == newBone)
//      return;
//
//    _unsubscribe();
//    _bone = newBone;
//    _subscribe(widget.outer(context, _bone), widget.initialData, widget.forceUpdate);
//  }
//
//  @override
//  Widget build(BuildContext context) => widget.builder(context, _bone, _state.data, _state);
//
//  @override
//  void dispose() {
//    _unsubscribe();
//    super.dispose();
//  }
//}
