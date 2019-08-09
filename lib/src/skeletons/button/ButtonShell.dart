import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';


class ButtonShell<B extends ButtonBone> extends StatefulWidget {
  final B buttonBone;
  final ButtonShield shield;
  final Widget child;

  const ButtonShell({Key key,
    this.buttonBone, this.shield: const ButtonShield(), this.child,
  }) : super(key: key);

  VoidCallback onPressed(BuildContext context, ButtonBone bone, bool isEnable) {
    return isEnable ?  () => bone.onPressed(() {}) : null;
  }

  @override
  _ButtonShellState<B, ButtonShell<B>> createState() => _ButtonShellState<B, ButtonShell<B>>();
}

class _ButtonShellState<B extends ButtonBone, TypeWidget extends ButtonShell<B>>
    extends State<TypeWidget> {
  ButtonBone _buttonBone;

  StreamSubscription _subscription;
  bool _sheet;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateButtonBone();
  }

  @override
  void didUpdateWidget(TypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttonBone != widget.buttonBone)
      _updateButtonBone();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _updateButtonBone() {
    final buttonBone = widget.buttonBone??BoneProvider.of<B>(context);
    assert(buttonBone != null);
    if (_buttonBone == buttonBone)
      return;

    _subscription?.cancel();
    _buttonBone = buttonBone;
    _sheet = null;
    _subscription = _buttonBone.outButtonSheet.listen(_sheetListener);
  }

  void _sheetListener(bool sheet) {
    setState(() {
      _sheet = sheet;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_sheet == null)
      return const Center(
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: const CircularProgressIndicator(),
        ),
      );

    return Button(
      shield: widget.shield,
      onPressed: widget.onPressed(context, _buttonBone, _sheet),
      child: widget.child,
    );
  }
}


class ButtonFocusedShell<B extends ButtonBone> extends ButtonShell<B> implements FocusShell {
  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  const ButtonFocusedShell({Key key,
    B buttonBone,
    this.mapFocusBone, this.focusNode,
    Widget child,
  }) : super(key: key,
    buttonBone: buttonBone, child: child,
  );

  @override
  _ButtonFocusedShellState<B, ButtonFocusedShell<B>> createState() => _ButtonFocusedShellState();
}

class _ButtonFocusedShellState<B extends ButtonBone, TypeWidget extends ButtonFocusedShell<B>>
    extends _ButtonShellState<B, TypeWidget>
    with FocusShellStateMixin<TypeWidget> {

  @override
  void initState() {
    super.initState();
    focusListener = _focusListener;
  }

  void _focusListener() {
    widget.onPressed(context, _buttonBone, _sheet);
  }
}


class ButtonFieldShell extends ButtonShell {
  const ButtonFieldShell({Key key,
    @required ButtonBone buttonBone, ButtonShield shield: const ButtonShield(), Widget child,
  }) : super(key: key, buttonBone: buttonBone, shield: shield, child: child);

  @override
  VoidCallback onPressed(BuildContext context, ButtonBone bone, bool isEnable) {
    return isEnable ? () {
      buttonBone.onPressed(() {
        final form = Form.of(context);
        if (!form.validate())
          throw "Not valid";
        form.save();
      });
    } : null;
  }
}