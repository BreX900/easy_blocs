import 'dart:async';
import 'dart:collection';

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
    assert(allowNull || skeleton != null, "Must [init]");
    return skeleton;
  }

  static void dispose<TypeSkeleton extends BlocBase>() {
    _cache.remove(TypeSkeleton)?.dispose();
  }
}

abstract class BlocBase extends Skeleton {}

abstract class BlocEvent extends BlocBase {
  Stream get outEvent;
}

mixin BlocScreenStateMixin<WidgetType extends StatefulWidget, BlocType extends BlocEvent>
    on State<WidgetType> {
  final BlocType bloc = BlocProvider.of<BlocType>();

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = bloc.outEvent.listen(eventListener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    BlocProvider.dispose<BlocType>();
    super.dispose();
  }

  Future<void> eventListener(event);
}
