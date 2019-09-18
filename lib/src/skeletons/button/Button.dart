import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/area/SafeArea.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget _ButtonShellBuilder(BuildContext context, bool state);

class ButtonShellBuilder extends StatefulWidget implements ObservableListener<bool> {
  final ButtonBone bone;
  final bool isEnableSafeArea;
  final _ButtonShellBuilder builder;

  const ButtonShellBuilder({
    Key key,
    @required this.bone,
    this.isEnableSafeArea: false,
    @required this.builder,
  }) : super(key: key);

  Stream<bool> get stream => bone.outStatus;

  @override
  _ButtonShellStateBuilder createState() => _ButtonShellStateBuilder();
}

class _ButtonShellStateBuilder extends State<ButtonShellBuilder>
    with
        SafePeopleState<ButtonShellBuilder>,
        ObservableListenerStateMixin<ButtonShellBuilder, bool> {
  bool _state;

  @override
  bool get isEnableSafeArea => widget.isEnableSafeArea;

  @override
  SafePeopleBone get people => widget.bone;

  @override
  void onChangeObservableState(ObservableState<bool> update) {
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
    this.clipBehavior: Clip.none,
    this.focusNode,
    this.child,
  }) : super(
            key: key,
            bone: bone,
            isEnableSafeArea: isEnableSafeArea,
            builder: ((BuildContext context, bool status) {
              if (status == null)
                return const Center(
                  child: const Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: const CircularProgressIndicator(),
                  ),
                );

              return Button.basic(
                buttonDesign: buttonDesign,
                onPressed: status ? bone.pressed : null,
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

abstract class ButtonBone extends Bone implements SafePeopleBone {
  Stream<bool> get outStatus;
  Future<void> pressed({AsyncCallback starter, AsyncCallback completed});
}

abstract class ButtonSkeletonBase extends Skeleton with SafePeopleSkeleton implements ButtonBone {
  ButtonSkeletonBase({
    bool status: true,
  }) : this._statusController = BehaviorSubject.seeded(status, sync: true);

  @override
  void dispose() {
    _statusController.close();
    super.dispose();
  }

  final BehaviorSubject<bool> _statusController;
  Stream<bool> get outStatus => _statusController;

  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed});

  /// TODO: Protected ???
  void inState(bool status) => _statusController.add(status);

  /// Not ovveride
  @override
  Future<void> pressed({AsyncCallback starter, AsyncCallback completed}) async {
    return workInSafeArea(() async {
      _statusController.add(null);
      await onPressed(starter: starter, completed: completed).then((_) {}, onError: (error) {
        _statusController.add(true);
      });
    });
  }
}

class ButtonSkeleton extends ButtonSkeletonBase implements ButtonBone {
  AsyncValueGetter<bool> onSubmit;
  ButtonSkeleton({
    bool status: true,
  }) : super(status: status);

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
