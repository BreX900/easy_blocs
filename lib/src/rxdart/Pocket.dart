import 'dart:async';
import 'dart:collection';

import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class Pocket {
  final HashMap<StreamController, TinyPocket> _pockets = HashMap();

  void put(
    StreamController controller, {
    void onListen(),
    void onCancel(),
  }) {
    assert(controller != null);
    _pockets[controller] = TinyPocket(controller, onListen: onListen, onCancel: onCancel);
  }

  TinyPocket operator [](StreamController controller) {
    assert(controller != null);
    return _pockets[controller];
  }

  TinyPocket putAndGet(
    StreamController controller, {
    void onListen(),
    void onCancel(),
  }) {
    assert(controller != null);
    final pocket = TinyPocket(controller, onListen: onListen, onCancel: onCancel);
    _pockets[controller] = pocket;
    return pocket;
  }

  TinyPocket putOrGet(
    StreamController controller, {
    void onListen(),
    void onCancel(),
  }) {
    assert(controller != null);
    if (!_pockets.containsKey(controller)) {
      put(controller, onListen: onListen, onCancel: onCancel);
    }
    return this[controller];
  }
}

mixin PocketWriters {
  final HashMap<String, StreamSubscription> _keyWriters = HashMap();

  void dispose() {
    _keyWriters.values.forEach((subscription) => subscription.cancel());
  }

  void insert<K>(StreamSubscription<K> subscription, {String key}) {
    key = key ?? K.toString();
    assert(_keyWriters[key] != null);
    _keyWriters[key] = subscription;
  }

  void put<K>(StreamSubscription<K> subscription, {String key}) {
    key = key ?? K.toString();
    _keyWriters[key]?.cancel();
    _keyWriters[key] = subscription;
  }

  void pop<K>({String key}) => _keyWriters[key ?? K.toString()]?.cancel();

  void remove<K>({String key}) => _keyWriters[key ?? K.toString()].cancel();
}

class TinyPocket<T> with PocketWriters {
  final StreamController<T> _controller;
  final List<ValueGetter<StreamSubscription>> _writers = [];
  List<StreamSubscription> _subscriptions;

  TinyPocket(
    this._controller, {
    void onListen(),
    void onCancel(),
  }) : assert(_controller != null) {
    _controller.onListen = () {
      if (_subscriptions != null)
        return;
      if (onListen != null) onListen();
      _subscriptions = _writers.map((source) => source()).toList();
    };
    _controller.onCancel = () {
      if (onCancel != null) onCancel();
      //_subscription?.cancel();
      _subscriptions?.forEach((sub) => sub.cancel());
      super.dispose();
    };
  }

  void addWriter(ValueGetter<StreamSubscription> writer) {
    if (writer != null) _writers.add(writer);
  }

  void catchSource<E>({
    @required ValueGetter<Stream<E>> source,
    @required void onData(E event),
    Function onError,
    void onDone(),
    bool cancelOnError: false,
  }) {
    assert(source != null && onData != null);

    addWriter(() => source()?.listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        ));
  }

  void catchStream<E>({
    String key,
    @required Stream<E> stream,
    @required void onData(E event),
    Function onError,
    void onDone(),
    bool cancelOnError: false,
  }) {
    assert(stream != null && onData != null);
    put<E>(stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    ));
  }

  void pipeSource(ValueGetter<FutureOr<Stream<T>>> source,
      {Function onError, void onDone(), bool cancelOnError}) {
    catchSource<T>(
      source: source,
      onData: _controller.add,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void pipeStream(
    Stream<T> stream, {
    Function onError,
    void onDone(),
    bool cancelOnError: false,
  }) {
    catchStream<T>(
      stream: stream,
      onData: _controller.add,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

//class _test extends StatefulWidget {
//  final MapFocusBone bone;
//  final FocusNode focusNode;
//
//  const _test({Key key, this.bone, this.focusNode}) : super(key: key);
//
//  @override
//  __testState createState() => __testState();
//}
//
//class __testState extends State<_test> {
//  DependencyHandler<MapFocusBone> _mapHandler;
//  DependencyHandler<FocusNode> _focusNodeHandler;
//
//  @override
//  void initState() {
//    super.initState();
//    _mapHandler = DependencyHandler(() => widget.bone??BoneProvider.of<MapFocusBone>(context));
//
//    _focusNodeHandler = DependencyHandler(() => widget.focusNode);
//
//    ExtendedPlugin2<MapFocusBone, FocusNode>(_mapHandler, _focusNodeHandler, (map, focus) {
//      map.addPointOfFocus(focus);
//    }, (map, focus) {
//      map.removePointOfFocus(focus);
//    });
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _mapHandler.didChangeDependencies();
//  }
//
//  @override
//  void didUpdateWidget(_test oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _focusNodeHandler.didUpdateWidget(widget.focusNode != oldWidget.focusNode);
//  }
//
//  @override
//  void dispose() {
//    _mapHandler.dispose();
//    _focusNodeHandler.dispose();
//    super.dispose();
//  }
//
//  void _listener() {
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

mixin PluginManagerMixin<WidgetType extends StatefulWidget> on State<WidgetType> {
  final List<Plugin> _plugins = [];
  final List<PluginManager> _byInherited = [], _byWidget = [];

  void addPlugin(Plugin plugin) => _plugins.add(plugin);
  void addManager(PluginManager manager, [byInherited = true]) {
    if (byInherited != false) {
      _byInherited.add(manager);
    }
    if (byInherited != true) {
      _byWidget.add(manager);
    }
  }

  @override
  void initState() {
    _plugins.forEach((plugin) => plugin.init(null));
    _byWidget.forEach((manager) => manager.initState());
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _byInherited.forEach((manager) => manager.update(oldWidget));
  }

  @override
  void didChangeDependencies() {
    _byWidget.forEach((manager) => manager.update());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _byInherited.forEach((manager) => manager.dispose());
    _byWidget.forEach((manager) => manager.dispose());
    _plugins.forEach((plugin) => plugin.close(null));
    super.dispose();
  }
}

class PluginManager<V> {
  final ValueToOne<StatefulWidget, V> _getter;
  final bool isDependencies;

  PluginManager(this._getter, [this.isDependencies = true]);

  V value;
  List<Plugin<V>> plugins = [];
  bool _isRequiredUpdate;

  void initState() {
    value = _getter(null);
    plugins.forEach((plugin) => plugin.init(value));
  }

  void update([StatefulWidget widget]) {
    try {
      final newValue = _getter(widget);
      assert(newValue != null);
      if (this.value != newValue) {
        plugins.forEach((plugin) => plugin.close(value));
        value = newValue;
        plugins.forEach((plugin) => plugin.init(value));
      }
    } catch (exc) {}
  }

  void dispose() => plugins.forEach((plugin) => plugin.close(value));
}

abstract class Plugin<V> {
  void init(V event);
  void close(V event);
}

class BasicPlugin<V> extends Plugin<V> {
  final ValueSetter<V> _init, _close;

  BasicPlugin(this._init, this._close);

  @override
  void init(V event) => _init(event);
  @override
  void close(V event) => _close(event);
}

class ExtendedPlugin2<F, S> {
  final PluginManager<F> _plugin1;
  final PluginManager<S> _plugin2;

  F _value1;
  S _value2;
  bool _isInit = false, _isClose = false;

  ExtendedPlugin2(
      this._plugin1, this._plugin2, void init(F value1, S value2), void close(F value1, S value2)) {
    _plugin1.plugins.add(BasicPlugin((value) {
      _value1 = value;

      init(_value1, _value2);
    }, (value) {
      close(value, _value2);
    }));
    _plugin2.plugins.add(BasicPlugin((value) {
      _value2 = value;
      init(_value1, _value2);
    }, (value) {
      close(_value1, value);
    }));
  }
}

class ListenerPlugin extends Plugin<Listenable> {
  final VoidCallback _listener;

  ListenerPlugin(this._listener);

  void init(Listenable listenable) {
    listenable.addListener(_listener);
  }

  void close(Listenable listenable) {
    listenable.removeListener(_listener);
  }
}

class SubscriberPlugin extends Plugin {
  final ValueGetter<StreamSubscription> _subscriber;
  StreamSubscription _subscription;

  SubscriberPlugin(this._subscriber);

  void init(listenable) {
    _subscription = _subscriber();
  }

  void close(listenable) {
    _subscription.cancel();
  }
}

class ObservablePlugin<V> extends Plugin {
  ObservablePlugin(this._widgetState, this._outer);

  final ValueGetter<Stream<V>> _outer;
  StreamSubscription _subscription;
  final State _widgetState;
  V _data;
  V get data => _data;
  Object _state;
  Object get state => _state;

  void init(listenable) {
    final stream = _outer();
    _subscription = stream.listen((data) {
      // ignore: invalid_use_of_protected_member
      _widgetState.setState(() {
        _data = data;
        _state = null;
      });
    }, onError: (error) {
      // ignore: invalid_use_of_protected_member
      _widgetState.setState(() {
        _state = error;
        _data = null;
      });
    });
    _data = stream is ValueObservable ? (stream as ValueObservable).value : null;
    _state = null;
  }

  void close(listenable) {
    _subscription.cancel();
  }
}

//class TinyPocket<T> extends PocketKey {
//  final StreamController<T> _controller;
//  final List<Function> _listeners = [];
//  final List<StreamSubscription> _onStart = [];
//
//
//  TinyPocket(this._controller, {
//    void onListen(), void onCancel(),
//  }) {
//    _controller.onListen = () {
//      if (onListen != null) onListen();
//      _listeners.forEach((function) => function());
//    };
//    _controller.onCancel = () {
//      if (onCancel != null) onCancel();
//      //_subscription?.cancel();
//      _onStart.forEach((sub) => sub.cancel());
//      super.dispose();
//    };
//  }
//
//  set subscription(StreamSubscription sub) => _onStart.add(sub);
//  set addListener(void listener()) => _listeners.add(listener);
//
//  void catchSource<E>({
//    @required ValueGetter<FutureOr<Stream<E>>> source, @required void onData(E event),
//    Function onError, void onDone(), bool cancelOnError: false,
//  }) {
//    assert(source != null && onData != null);
//
//    addListener = () async {
//      final raw = source();
//      subscription =  (raw is Future ? (await raw) : raw as Stream<E>).listen(onData,
//        onError: onError, onDone: onDone, cancelOnError: cancelOnError,
//      );
//    };
//  }
//
//  void catchStream<E>({String key,
//    @required Stream<E> stream, @required void onData(E event),
//    Function onError, void onDone(), bool cancelOnError: false,
//  }) {
//    assert(stream != null && onData != null);
//    putSubscription(stream.listen(onData,
//      onError: onError, onDone: onDone, cancelOnError: cancelOnError,
//    ));
//  }
//
//  void pipeSource(ValueGetter<FutureOr<Stream<T>>> source, {
//    Function onError, void onDone(), bool cancelOnError
//  }) {
//    catchSource<T>(
//      source: source,
//      onData: _controller.add, onError: onError, onDone: onDone, cancelOnError: cancelOnError,
//    );
//  }
//
//  void pipeStream(Stream<T> stream, {
//    Function onError, void onDone(), bool cancelOnError: false,
//  }) {
//    catchStream<T>(
//      stream: stream, onData: _controller.add,
//      onError: onError, onDone: onDone, cancelOnError: cancelOnError,
//    );
//  }
//
//}

//class TinyPocketBase<V> {
//  StreamSubscription<V> _subscription;
//
//  set subscription(StreamSubscription<V> subscription) {
//    _subscription?.cancel();
//    _subscription = subscription;
//  }
//
//  TinyPocketBase([this._subscription]);
//
//  void dispose() {
//    _subscription?.cancel();
//  }
//}
//class PocketBase {
//  final HashMap<Type, TinyPocketBase> _pockets = HashMap();
//
//  void addSubscription<V>(StreamSubscription<V> subscription) {
//    final pocket = _pockets[V];
//    if (pocket == null) {
//      _pockets[V] = TinyPocketBase<V>(subscription);
//    } else {
//      pocket.subscription = subscription;
//    }
//  }
//
//  void dispose() {
//    _pockets.values.forEach((subscription) => subscription.dispose());
//  }
//}

//class StatePocket<V> {
//  final ValueGetter<V> initialization;
//  V _value;
//  V get value => _value;
//  final VoidCallback processing, demolition;
//
//  StatePocket([this.initialization, this.processing, this.demolition]);
//
//  void _initState() {
//    _value = initialization();
//    processing();
//  }
//
//  void _didChangeDependencies() {
//    final newValue = initialization();
//    if (_value != newValue) {
//      demolition();
//      _value = newValue;
//      processing();
//    }
//  }
//  void _dispose() {
//    demolition();
//  }
//}
//
//mixin StatePocketMixin<W extends StatefulWidget> on State<W> {
//  final List<StatePocket> _pockets = [];
//
//  set pocket(StatePocket pocket) => _pockets.add(pocket);
//
//  @override
//  void initState() {
//    super.initState();
//    _pockets.forEach((pocket) => pocket._initState());
//  }
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _pockets.forEach((pocket) => pocket._didChangeDependencies());
//  }
//  @override
//  void dispose() {
//    _pockets.forEach((pocket) => pocket._dispose());
//    super.dispose();
//  }
//}
