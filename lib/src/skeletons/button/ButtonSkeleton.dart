import 'dart:async';

import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';




class ButtonSkeleton extends Skeleton implements ButtonBone {
  AsyncValueGetter<bool> onSubmit;

  ButtonSkeleton({
    bool isEnable: true,
  }) : this._buttonController = BehaviorSubject.seeded(isEnable);

  final BehaviorSubject<bool> _buttonController;
  Stream<bool> get outButtonSheet => _buttonController;


  @override
  void dispose() {
    _buttonController.close();
    super.dispose();
  }

  @override
  Future<void> onPressed(VoidCallback starter) async {
    assert(onSubmit != null);
    _buttonController.add(null);
    try {
      starter();
      onSubmit().then(_buttonController.add);
    } catch(exc) {
      _buttonController.add(true);
    }
  }

  void add(bool isEnable) => _buttonController.add(isEnable);
}


abstract class ButtonBone extends Bone {
  Stream<bool> get outButtonSheet;
  Future<void> onPressed(VoidCallback starter);
}