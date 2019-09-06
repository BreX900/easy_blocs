import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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

class MapWriters {
  final HashMap<String, StreamSubscription> _keyWriters = HashMap();

  void dispose() {
    _keyWriters.values.forEach((subscription) => subscription.cancel());
  }

//  void put<K>(StreamSubscription<K> subscription, {String key}) {
//    key = key ?? K.toString();
//    assert(_keyWriters[key] != null);
//    _keyWriters[key] = subscription;
//  }

  void put<K>(StreamSubscription<K> subscription, {String key}) {
    key = key ?? K.toString();
    _keyWriters[key]?.cancel();
    _keyWriters[key] = subscription;
  }

  void pop<K>({String key}) => _keyWriters[key ?? K.toString()]?.cancel();

//  void popAndClose<K>({String key}) => _keyWriters[key ?? K.toString()].cancel();
}

abstract class ListWriters {
  List<ValueGetter<StreamSubscription>> _writers = [];
  List<StreamSubscription> _subscriptions = [];

  set addWriter(ValueGetter<StreamSubscription> writer) {
    if (writer != null) _writers.add(writer);
  }

  void writer();

  void unsubscribe() {
    _subscriptions.forEach((sub) => sub?.cancel());
    _subscriptions = [];
  }

  void dispose() {
    unsubscribe();
    _writers = null;
    _subscriptions = null;
  }
}

class OnceWriters extends ListWriters {
  @override
  void writer() {
    _subscriptions.addAll(_writers.map((source) => source()));
    _writers = [];
  }
}

class RepeatWriters extends ListWriters {
  @override
  void writer() {
    unsubscribe();
    _subscriptions.addAll(_writers.map((source) => source()));
  }
}

typedef Stream<V> StreamSource<V>();

class TinyPocket<T> {
  final StreamController<T> _controller;
  final ListWriters _onceWriters = OnceWriters(), _repeatWriters = RepeatWriters();
  bool isStart = false;
  final MapWriters _writers = MapWriters();

  TinyPocket(
    this._controller, {
    void onListen(),
    void onCancel(),
  }) {
    _controller.onListen = () async {
      if (onListen != null) onListen();
      _onceWriters.writer();
      _repeatWriters.writer();
    };
    _controller.onCancel = () async {
      if (onCancel != null) onCancel();
      _onceWriters.dispose();
      _repeatWriters.dispose();
      _writers.dispose();
    };
  }

  void addWriter<E>(ValueGetter<StreamSubscription<E>> writer, {bool repeat: false}) {
    assert(writer != null);
    if (repeat)
      _repeatWriters.addWriter = writer;
    else
      _onceWriters.addWriter = writer;
  }

  void catchSource<E>({
    @required StreamSource<E> source,
    @required void onData(E event),
    Function onError,
    void onDone(),
    bool cancelOnError: false,
    bool repeat: false,
  }) {
    addWriter(
        () => source()?.listen(
              onData,
              onError: onError,
              onDone: onDone,
              cancelOnError: cancelOnError,
            ),
        repeat: repeat);
  }

  void pipeSource(
    StreamSource<T> source, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
    bool repeat: false,
  }) {
    catchSource(
      source: source,
      onData: _controller.add,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
      repeat: repeat,
    );
  }

  void put<K>(StreamSubscription<K> subscription, {String key}) =>
      _writers.put(subscription, key: key);

  void pop<K>({String key}) => _writers.pop(key: key);

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

//mixin PluginManagerMixin<WidgetType extends StatefulWidget> on State<WidgetType> {
//  final List<Plugin> _plugins = [];
//  final List<PluginManager> _byInherited = [], _byWidget = [];
//
//  void addPlugin(Plugin plugin) => _plugins.add(plugin);
//  void addManager(PluginManager manager, [byInherited = true]) {
//    if (byInherited != false) {
//      _byInherited.add(manager);
//    }
//    if (byInherited != true) {
//      _byWidget.add(manager);
//    }
//  }
//
//  @override
//  void initState() {
//    _plugins.forEach((plugin) => plugin.init(null));
//    _byWidget.forEach((manager) => manager.initState());
//    super.initState();
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _byInherited.forEach((manager) => manager.update(oldWidget));
//  }
//
//  @override
//  void didChangeDependencies() {
//    _byWidget.forEach((manager) => manager.update());
//    super.didChangeDependencies();
//  }
//
//  @override
//  void dispose() {
//    _byInherited.forEach((manager) => manager.dispose());
//    _byWidget.forEach((manager) => manager.dispose());
//    _plugins.forEach((plugin) => plugin.close(null));
//    super.dispose();
//  }
//}
//
//class PluginManager<V> {
//  final ValueToOne<StatefulWidget, V> _getter;
//  final bool isDependencies;
//
//  PluginManager(this._getter, [this.isDependencies = true]);
//
//  V value;
//  List<Plugin<V>> plugins = [];
//  bool _isRequiredUpdate;
//
//  void initState() {
//    value = _getter(null);
//    plugins.forEach((plugin) => plugin.init(value));
//  }
//
//  void update([StatefulWidget widget]) {
//    try {
//      final newValue = _getter(widget);
//      assert(newValue != null);
//      if (this.value != newValue) {
//        plugins.forEach((plugin) => plugin.close(value));
//        value = newValue;
//        plugins.forEach((plugin) => plugin.init(value));
//      }
//    } catch (exc) {}
//  }
//
//  void dispose() => plugins.forEach((plugin) => plugin.close(value));
//}
//
//abstract class Plugin<V> {
//  void init(V event);
//  void close(V event);
//}
//
//class BasicPlugin<V> extends Plugin<V> {
//  final ValueSetter<V> _init, _close;
//
//  BasicPlugin(this._init, this._close);
//
//  @override
//  void init(V event) => _init(event);
//  @override
//  void close(V event) => _close(event);
//}
//
//class ExtendedPlugin2<F, S> {
//  final PluginManager<F> _plugin1;
//  final PluginManager<S> _plugin2;
//
//  F _value1;
//  S _value2;
//  bool _isInit = false, _isClose = false;
//
//  ExtendedPlugin2(
//      this._plugin1, this._plugin2, void init(F value1, S value2), void close(F value1, S value2)) {
//    _plugin1.plugins.add(BasicPlugin((value) {
//      _value1 = value;
//
//      init(_value1, _value2);
//    }, (value) {
//      close(value, _value2);
//    }));
//    _plugin2.plugins.add(BasicPlugin((value) {
//      _value2 = value;
//      init(_value1, _value2);
//    }, (value) {
//      close(_value1, value);
//    }));
//  }
//}
//
//class ListenerPlugin extends Plugin<Listenable> {
//  final VoidCallback _listener;
//
//  ListenerPlugin(this._listener);
//
//  void init(Listenable listenable) {
//    listenable.addListener(_listener);
//  }
//
//  void close(Listenable listenable) {
//    listenable.removeListener(_listener);
//  }
//}
//
//class SubscriberPlugin extends Plugin {
//  final ValueGetter<StreamSubscription> _subscriber;
//  StreamSubscription _subscription;
//
//  SubscriberPlugin(this._subscriber);
//
//  void init(listenable) {
//    _subscription = _subscriber();
//  }
//
//  void close(listenable) {
//    _subscription.cancel();
//  }
//}
//
//class ObservablePlugin<V> extends Plugin {
//  ObservablePlugin(this._widgetState, this._outer);
//
//  final ValueGetter<Stream<V>> _outer;
//  StreamSubscription _subscription;
//  final State _widgetState;
//  V _data;
//  V get data => _data;
//  Object _state;
//  Object get state => _state;
//
//  void init(listenable) {
//    final stream = _outer();
//    _subscription = stream.listen((data) {
//      // ignore: invalid_use_of_protected_member
//      _widgetState.setState(() {
//        _data = data;
//        _state = null;
//      });
//    }, onError: (error) {
//      // ignore: invalid_use_of_protected_member
//      _widgetState.setState(() {
//        _state = error;
//        _data = null;
//      });
//    });
//    _data = stream is ValueObservable ? (stream as ValueObservable).value : null;
//    _state = null;
//  }
//
//  void close(listenable) {
//    _subscription.cancel();
//  }
//}
