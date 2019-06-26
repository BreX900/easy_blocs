import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:flutter/widgets.dart';


/// Must call [hand.dispose()]
@deprecated
mixin MixinHand implements Hand {
  Hand get hand;

  void dispose() {
    hand.dispose();
  }

  @override
  void addFinger(Finger finger) {
    hand.addFinger(finger);
  }

  bool nextFinger(BuildContext context, Finger finger) {
    return hand.nextFinger(context, finger);
  }
}