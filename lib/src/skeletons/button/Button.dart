import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/area/SafeArea.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget _ButtonShellBuilder(BuildContext context, ButtonState state);

class ButtonShellBuilder extends StatefulWidget implements ObservableListener<ButtonState> {
  final ButtonBone bone;
  final bool isEnableSafeArea;
  final _ButtonShellBuilder builder;

  const ButtonShellBuilder({
    Key key,
    @required this.bone,
    this.isEnableSafeArea: false,
    @required this.builder,
  }) : super(key: key);

  Stream<ButtonState> get stream => bone.outState;

  @override
  _ButtonShellStateBuilder createState() => _ButtonShellStateBuilder();
}

class _ButtonShellStateBuilder extends State<ButtonShellBuilder>
    with
        SafePeopleState<ButtonShellBuilder>,
        ObservableListenerStateMixin<ButtonShellBuilder, ButtonState> {
  ButtonState _state;

  @override
  bool get isEnableSafeArea => widget.isEnableSafeArea;

  @override
  SafePeopleBone get people => widget.bone;

  @override
  void onChangeObservableState(ObservableState<ButtonState> update) {
    setState(() => _state = update.data);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }
}

class ButtonShell extends ButtonShellBuilder {
  final ButtonDesign buttonDesign;
  final ButtonTextTheme textTheme;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final FocusNode focusNode;
  final Widget child;

  ButtonShell({
    Key key,
    @required ButtonBone bone,
    bool isEnableSafeArea: false,
    this.buttonDesign: ButtonDesign.raised,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.padding,
    this.shape,
    this.clipBehavior,
    this.focusNode,
    this.child,
  }) : super(
            key: key,
            bone: bone,
            isEnableSafeArea: isEnableSafeArea,
            builder: ((BuildContext context, ButtonState state) {
              if (state == ButtonState.working)
                return const Center(
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const CircularProgressIndicator(),
                  ),
                );

              return Button.basic(
                buttonDesign: buttonDesign,
                onPressed: state == ButtonState.enabled ? bone.pressed : null,
                textTheme: textTheme,
                textColor: textColor,
                disabledTextColor: disabledTextColor,
                color: color,
                disabledColor: disabledColor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                splashColor: splashColor,
                shape: shape,
                clipBehavior: clipBehavior,
                focusNode: focusNode,
                child: child,
              );
            }));
}

enum ButtonState {
  enabled,
  disabled,
  working,
}

abstract class ButtonBone extends Bone implements SafePeopleBone {
  Stream<ButtonState> get outState;
  Future<void> pressed({AsyncCallback starter, AsyncCallback completed});
}

abstract class ButtonSkeletonBase extends Skeleton with SafePeopleSkeleton implements ButtonBone {
  ButtonSkeletonBase({
    ButtonState state: ButtonState.enabled,
  }) : this._stateController = BehaviorSubject.seeded(state, sync: true);

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }

  final BehaviorSubject<ButtonState> _stateController;
  Stream<ButtonState> get outState => _stateController;

  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed});

  /// TODO: Protected ???
  void inState(ButtonState state) => _stateController.add(state);

  /// Not ovveride
  @override
  Future<void> pressed({AsyncCallback starter, AsyncCallback completed}) async {
    return workInSafeArea(() async {
      _stateController.add(ButtonState.working);
      onPressed(starter: starter, completed: completed).then((_) {}, onError: (error) {
        _stateController.add(ButtonState.enabled);
      });
    });
  }
}

class ButtonSkeleton extends ButtonSkeletonBase implements ButtonBone {
  AsyncValueGetter<ButtonState> onSubmit;
  ButtonSkeleton({
    ButtonState state: ButtonState.enabled,
  }) : super(state: state);

  @override
  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed}) async {
    assert(onSubmit != null);
    if (starter != null) await starter();
    final res = await onSubmit();
    inState(res);
    if (completed != null) await completed();
    return res;
  }
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
