import 'dart:async';
import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/widgets.dart';


class BlocProvider {
  static final _cache = HashMap<Type, BlocBase>();

  static TypeSkeleton init<TypeSkeleton extends BlocBase>(TypeSkeleton bloc) {
    assert(!_cache.containsKey(TypeSkeleton), "Already contain $TypeSkeleton");
    _cache[TypeSkeleton] = bloc;
    return bloc;
  }

  static Skeleton of<TypeSkeleton extends BlocBase>([bool allowNull = false]) {
    final skeleton = _cache[TypeSkeleton];
    assert(!allowNull || skeleton != null);
    return skeleton;
  }

  static void dispose<TypeSkeleton extends BlocBase>() {
    _cache.remove(TypeSkeleton)?.dispose();
  }
}


abstract class BlocBase extends Skeleton {

}


abstract class BlocScreen<M> extends BlocBase {
  Stream get outEvent;

  Stream<M> get outData;
}


mixin ListenerDataMixin<WidgetType extends StatefulWidget, D> on State<WidgetType> {
  Stream get outData;

  StreamSubscription _dataSubscription;

  D _data;
  D get data => _data;

  Object _error;
  Object get error => _error;

  @override
  void initState() {
    super.initState();
    _dataSubscription = outData.listen((data) => setState(() {
      _data = data;
      _error = null;
    }), onError: (error) => setState(() {
      _error = error;
      _data = null;
    }));
  }

  @override
  void dispose() {
    _dataSubscription.cancel();
    super.dispose();
  }
}


mixin ListenerEventMixin<WidgetType extends StatefulWidget> on State<WidgetType> {
  @required
  Stream outEvent;

  StreamSubscription _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = outEvent.listen(listenerEvent);
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  void listenerEvent(event);
}