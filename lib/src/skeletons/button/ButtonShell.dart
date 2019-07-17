import 'dart:async';

import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/button/ButtonBone.dart';
import 'package:flutter/material.dart';


class ButtonShell<B extends ButtonBone> extends StatefulWidget {
  final B bone;
  final Widget child;

  const ButtonShell({Key key, this.child, this.bone}) : super(key: key);

  @override
  _ButtonShellState<B> createState() => _ButtonShellState<B>();
}

class _ButtonShellState<B extends ButtonBone> extends State<ButtonShell<B>> {
  ButtonBone _manager;

  StreamSubscription _subscription;
  bool _sheet = false;

  @override
  void initState() {
    super.initState();
    _manager = widget.bone??BoneProvider.of<B>(context);
    assert(_manager != null);
    _subscription = _manager.outButtonSheet.listen(_sheetListener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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

    return MaterialButton(
      onPressed: _sheet ?  _manager.onPressed : null,
      child: widget.child,
    );
  }
}