import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class ButtonShell extends StatefulWidget {
  final ButtonBone bone;

  final ButtonShield shield;
  final Widget child;

  const ButtonShell({Key key,
    @required this.bone,
    this.shield: const ButtonShield(), this.child,
  }) : super(key: key);

  @override
  _ButtonShellState createState() => _ButtonShellState();
}

class _ButtonShellState extends State<ButtonShell> {

  ObservableSubscriber<ButtonState> _stateSubscriber;
  ButtonState _state;

  @override
  void initState() {
    super.initState();
    _stateSubscriber = ObservableSubscriber(_stateListener)..subscribe(widget.bone.outState);
  }

  @override
  void didUpdateWidget(ButtonShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _stateSubscriber..unsubscribe()..subscribe(widget.bone.outState);
    }
  }

  @override
  void dispose() {
    _stateSubscriber.unsubscribe();
    super.dispose();
  }

  void _stateListener(ObservableState<ButtonState> update) {
    setState(() => _state = update.data);
  }

  @override
  Widget build(BuildContext context) {

    if (_state == null)
      return const Center(
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: const CircularProgressIndicator(),
        ),
      );

    return Button(
      shield: widget.shield,
      onPressed: _state == ButtonState.enabled ? widget.bone.onPressed : null,
      child: widget.child,
    );
  }
}



enum ButtonState {
  enabled, disabled, working,
}

abstract class ButtonBone extends Bone {
  Stream<ButtonState> get outState;
  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed});
}

class ButtonSkeleton extends Skeleton implements ButtonBone {
  AsyncValueGetter<ButtonState> onSubmit;

  ButtonSkeleton({
    ButtonState state: ButtonState.enabled,
  }) : this._stateController = BehaviorSubject.seeded(state);

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }

  final BehaviorSubject<ButtonState> _stateController;
  Stream<ButtonState> get outState => _stateController;

  @override
  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed}) async {
    assert(onSubmit != null);
    _stateController.add(ButtonState.working);
    _onPressed(starter: starter, completed: completed).then(_stateController.add, onError: (error) {
      _stateController.add(ButtonState.enabled);
    });
  }
  Future<void> _onPressed({AsyncCallback starter, AsyncCallback completed}) async {
    if (starter != null)
      await starter();
    return await onSubmit();
  }
  /// TODO: Protected ???
  void addState(ButtonState state) => _stateController.add(state);
}








/// WITH FOCUS

//
//class ButtonFocusedShell<B extends ButtonBone> extends ButtonShell<B> implements FocusShell {
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  const ButtonFocusedShell({Key key,
//    B buttonBone,
//    this.mapFocusBone, this.focusNode,
//    Widget child,
//  }) : super(key: key,
//    buttonBone: buttonBone, child: child,
//  );
//
//  @override
//  _ButtonFocusedShellState<B, ButtonFocusedShell<B>> createState() => _ButtonFocusedShellState();
//}
//
//class _ButtonFocusedShellState<B extends ButtonBone, TypeWidget extends ButtonFocusedShell<B>>
//    extends _ButtonShellState<B, TypeWidget>
//    with FocusShellStateMixin<TypeWidget> {
//
//  @override
//  void initState() {
//    super.initState();
//    //focusListener = _focusListener;
//  }
//
//  void _focusListener() {
//    widget.onPressed(context, _buttonBone, _sheet);
//  }
//}
//
//
//class ButtonFieldShell extends ButtonShell {
//  const ButtonFieldShell({Key key,
//    @required ButtonBone buttonBone, ButtonShield shield: const ButtonShield(), Widget child,
//  }) : super(key: key, buttonBone: buttonBone, shield: shield, child: child);
//
//  @override
//  VoidCallback onPressed(BuildContext context, ButtonBone bone, bool isEnable) {
//    return isEnable ? () {
//      buttonBone.onPressed(() {
//        final form = Form.of(context);
//        if (!form.validate())
//          throw "Not valid";
//        form.save();
//      });
//    } : null;
//  }
//}