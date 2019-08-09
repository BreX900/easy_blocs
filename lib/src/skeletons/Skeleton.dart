

import 'package:flutter/cupertino.dart';

class Skeleton implements Bone {
  @mustCallSuper
  void dispose() {}
}


abstract class Bone {

}


mixin SkeletonWriter on Skeleton {

}

class SkeletonEvent<E> extends Skeleton {

}