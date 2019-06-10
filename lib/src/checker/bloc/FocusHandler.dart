import 'package:easy_blocs/src/checker/bloc/SubmitBloc.dart';
import 'package:flutter/widgets.dart';


class Hand {
  final List<Finger> _fingers;

  Hand({Set<Finger> fingers}) : _fingers = fingers?.toList()??[];

  bool nextFinger(BuildContext context, Finger finger) {
    final index = _fingers.indexWhere((fn) => fn == finger)+1;
    try {
      _fingers[index].acquire(context);
      return true;
    } catch(exc) {
      return false;
    }
  }

  void addFinger(Finger finger) => _fingers.contains(finger) ? null : _fingers.add(finger);
}


abstract class Finger {
  @mustCallSuper
  Finger(Hand hand) : assert(hand != null) {
    hand.addFinger(this);
  }

  void nextFinger(BuildContext context);
  void acquire(BuildContext context);
}


class FingerNode extends Finger {
  final Hand _hand;
  final FocusNode focusNode;

  FingerNode({
    @required Hand hand, FocusNode focusNode,
  }) : this._hand = hand, this.focusNode = focusNode??FocusNode(), super(hand);

  @override
  void acquire(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  void nextFinger(BuildContext context) {
    _hand.nextFinger(context, this);
  }
}


class CallbackFinger extends Finger {
  final VoidCallback onAcquire;

  CallbackFinger({
    @required this.onAcquire, @required Hand hand,
  }) : assert(onAcquire != null), super(hand);

  CallbackFinger.bloc(SubmitBloc bloc) : assert(bloc != null), onAcquire = bloc.submit, super(bloc);

  @override
  acquire(BuildContext context) => onAcquire();

  @override
  void nextFinger(BuildContext context) => null;
}

