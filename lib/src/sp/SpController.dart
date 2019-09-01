import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' show Window;

abstract class SpBone extends Bone {
  Sp get sp;
//  void inWindow(Window window);
}

class SpSkeleton extends Skeleton implements SpBone {
  BehaviorSubject<Sp> _spController = BehaviorSubject();
  Sp get sp => _spController.value;
  Stream<Sp> get outSp => _spController;

  void inWindow(Window window) {
    inMediaQueryData(MediaQueryData.fromWindow(window));
  }
  void inMediaQueryData(MediaQueryData data) {
    final newSp = Sp.fromMediaQueryData(data);
    if (sp == null) _spController.value = newSp;
    if (newSp == null || sp.sameTo(newSp)) return;
    _spController.value = newSp;
  }
}

mixin MixinSpManager implements SpBone {
  SpBone get spManager;
  Sp get sp => spManager.sp;
//  void inWindow(Window window) => spManager.inWindow(window);
}

//mixin SpObserver<W extends StatefulWidget> on WidgetsBindingStateListener<W> {
//  SpBone get spManager;
//
//  void didChangeMetrics() {
//    super.didChangeMetrics();
//    spManager.inWindow(widgetsBinding.window);
//  }
//}
