import 'package:easy_blocs/src/old/checker/controllers/SubmitController.dart';
import 'package:flutter/widgets.dart';

class Hand {
  final List<Finger> _fingers;

  Hand({Set<Finger> fingers}) : _fingers = fingers?.toList() ?? [];

  bool nextFinger(BuildContext context, Finger finger) {
    final index = _fingers.indexWhere((fn) => fn == finger) + 1;
    try {
      _fingers[index].acquire(context);
      return true;
    } catch (exc) {
      return false;
    }
  }

  void addFinger(Finger finger) => _fingers.contains(finger) ? null : _fingers.add(finger);

  void dispose() {
    _fingers.forEach((finger) => finger.dispose());
  }
}

abstract class Finger {
  @mustCallSuper
  Finger(Hand hand) : assert(hand != null) {
    hand.addFinger(this);
  }

  void acquire(BuildContext context);
  void dispose() {}
}

class FingerNode extends Finger {
  final FocusNode focusNode;

  FingerNode({
    @required Hand hand,
    FocusNode focusNode,
  })  : this.focusNode = focusNode ?? FocusNode(),
        super(hand);

  @override
  void acquire(BuildContext context) {
    FocusScope.of(context).autofocus(focusNode);
  }

  @override
  @mustCallSuper
  void dispose() {
    focusNode.dispose();
  }
}

class CallbackFinger extends Finger {
  final VoidCallback onAcquire;

  CallbackFinger({
    @required this.onAcquire,
    @required Hand hand,
  })  : assert(onAcquire != null),
        super(hand);

  CallbackFinger.controller({
    @required SubmitController controller,
    @required Hand hand,
  })  : assert(controller != null),
        onAcquire = controller.onSubmit,
        super(hand);

  @override
  acquire(BuildContext context) => onAcquire();
}
