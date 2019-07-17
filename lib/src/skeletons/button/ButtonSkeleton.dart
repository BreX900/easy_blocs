import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'ButtonBone.dart';


class ButtonSkeleton extends Skeleton implements ButtonBone {
  VoidCallback onSubmit;

  ButtonSkeleton({
    bool isEnable: true,
  }) : controller = BehaviorSubject.seeded(isEnable);

  final BehaviorSubject<bool> controller;
  Stream<bool> get outButtonSheet => controller.stream;

  Future<void> onPressed() async {
    controller.add(null);
    if (onSubmit != null)
      onSubmit();
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}