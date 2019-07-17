import 'package:easy_blocs/src/skeletons/button/ButtonSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/button/ButtonFieldBone.dart';
import 'package:flutter/widgets.dart';


class ButtonFieldSkeleton extends ButtonSkeleton implements ButtonFieldBone {
  final FocusNode focusNode;

  ButtonFieldSkeleton({
    bool isEnable: true, this.focusNode,
  }) : super(
    isEnable: isEnable,
  ) {
    focusNode?.addListener(_focusListener);
  }

  void _focusListener() {
    onPressed();
  }
}
