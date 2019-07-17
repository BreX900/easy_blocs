import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';


class SkeletonProvider {
  static final _cache = HashMap<Type, Skeleton>();

  static void init<TypeSkeleton extends Skeleton>(TypeSkeleton skeleton) {
    assert(!_cache.containsKey(TypeSkeleton), "Already contain $TypeSkeleton");
    _cache[TypeSkeleton] = skeleton;
  }

  static Skeleton of<TypeSkeleton extends Skeleton>({bool isNullable: false}) {
    final skeleton = _cache[TypeSkeleton];
    assert(!isNullable || skeleton != null);
    return skeleton;
  }

  static void dispose<TypeSkeleton extends Skeleton>() {
    _cache.remove(TypeSkeleton)?.dispose();
  }
}