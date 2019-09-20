import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/widgets.dart';

class BlocProvider {
  static HashMap<Type, BlocBase> _cache = HashMap<Type, BlocBase>();

  static TypeSkeleton init<TypeSkeleton extends BlocBase>(TypeSkeleton bloc) {
    assert(!_cache.containsKey(TypeSkeleton), "Already contain $TypeSkeleton");
    _cache[TypeSkeleton] = bloc;
    return bloc;
  }

  static Skeleton of<TypeSkeleton extends BlocBase>([bool allowNull = false]) {
    final skeleton = _cache[TypeSkeleton];
    assert(allowNull || skeleton != null, "Use [$TypeSkeleton.init()] for uinitialization");
    return skeleton;
  }

  static void dispose<TypeSkeleton extends BlocBase>() {
    _cache.remove(TypeSkeleton)?.dispose();
  }
}

abstract class BlocBase extends Skeleton {}

abstract class BlocEvent extends BlocBase {
  void dispose() {
    super.dispose();
    _onEventCompleter = null;
  }

  Completer<AsyncValueSetter> _onEventCompleter = Completer();
  set onEvent(AsyncValueSetter onEvent) {
    if (_onEventCompleter == null) throw "Is closed";
    if (_onEventCompleter.isCompleted) {
      _onEventCompleter = null;
      return;
    }
    _onEventCompleter.complete(onEvent);
  }

  @protected
  Future<void> addEvent(event) {
    assert(_onEventCompleter != null);
    assert(event != null);
    if (_onEventCompleter == null) return null;
    return _onEventCompleter.future.then((onEvent) => onEvent(event));
  }
}

mixin BlocScreenStateMixin<WidgetType extends StatefulWidget, BlocType extends BlocEvent>
    on State<WidgetType> {
  final BlocType bloc = BlocProvider.of<BlocType>();

  @override
  void initState() {
    super.initState();
    bloc.onEvent = eventListener;
  }

  @override
  void dispose() {
    BlocProvider.dispose<BlocType>();
    super.dispose();
  }

  Future<void> eventListener(event);
}

abstract class ScreenState<WidgetType extends StatefulWidget, BlocType extends BlocEvent>
    extends State<WidgetType> with BlocScreenStateMixin<WidgetType, BlocType> {}
