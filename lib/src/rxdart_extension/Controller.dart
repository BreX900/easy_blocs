import 'dart:async';

import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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


mixin _Subscriber<WidgetType extends StatefulWidget, V> on State<WidgetType> {
  StreamSubscription<V> _subscription;
  ObservableState<V> _state;

  void _subscribe(Stream<V> stream, V initialData, bool forceUpdate) {
    _subscription = stream.listen((V data) {
      if (_state.data != data || (forceUpdate && _state is !ActiveState))
        setState(() => _state = ActiveState(data: data));
    }, onError: (Object error) {
      if (_state.error != error || (forceUpdate && _state is !ErrorState))
        setState(() => _state = ErrorState(error: error));
    }, onDone: () {
      if (forceUpdate && _state is !DoneState)
        setState(() => _state = DoneState(data: _state.data, error: _state.error));
    });
    _state = WaitingState(data: stream is ValueObservable<V>
        ? stream.value??initialData
        : initialData);
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}


typedef Widget _ObservableBuilder<V>(BuildContext context, V value, ObservableState state);

class ObservableBuilder<V> extends StatefulWidget {

  ObservableBuilder(this.builder, {
    Key key,
    this.initialData,
    @required this.stream,
    this.forceUpdate: false,
  }) : assert(builder != null),
        assert(stream != null),
        super(key: key);

  final _ObservableBuilder<V> builder;

  final V initialData;

  final Stream<V> stream;

  final bool forceUpdate;

  @override
  _ObservableBuilderState<V> createState() => _ObservableBuilderState<V>();
}

class _ObservableBuilderState<V> extends State<ObservableBuilder<V>> with _Subscriber {
  @override
  void initState() {
    super.initState();
    _subscribe(widget.stream, widget.initialData, widget.forceUpdate);
  }

  @override
  void didUpdateWidget(ObservableBuilder<V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _unsubscribe();
      _subscribe(widget.stream, widget.initialData, widget.forceUpdate);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _state.data, _state);
}


typedef Widget _BoneBuilder<B extends Bone, V>(
    BuildContext context, B bone, V value, ObservableState state);
typedef Stream<V> _Strimmer<B extends Bone, V>(BuildContext context, B bone);

class BoneBuilder<B extends Bone, V> extends StatefulWidget {

  BoneBuilder(this.builder, {
    Key key,
    this.initialData,
    @required this.outer,
    this.forceUpdate: false,
  }) : assert(builder != null),
        assert(outer != null),
        super(key: key);

  final _BoneBuilder<B, V> builder;

  final V initialData;

  final _Strimmer<B, V> outer;

  final forceUpdate;

  @override
  BoneBuilderState<B, V> createState() => BoneBuilderState<B, V>();
}

class BoneBuilderState<B extends Bone, V> extends State<BoneBuilder<B, V>> with _Subscriber {
  B _bone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newBone = BoneProvider.of<B>(context, false);

    if (_bone == newBone)
      return;

    _unsubscribe();
    _bone = newBone;
    _subscribe(widget.outer(context, _bone), widget.initialData, widget.forceUpdate);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _bone, _state.data, _state);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
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
        child: Center(child: const CircularProgressIndicator()),
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
        child: Center(child: Text("!!! ERROR !!!\n$error")),
      ),
    );
  }
}
