import 'dart:async';

import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/button/Button.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


abstract class ButtonFieldBone extends Bone implements FieldBoneBase, ButtonBone {
  set formBone(FormBone formBone);
  FormBone _formBone;
}

class ButtonFieldSkeleton extends ButtonSkeleton with FieldSkeletonBase implements ButtonFieldBone {
  FormBone _formBone;

  @override
  set formBone(FormBone formBone) => _formBone = formBone;

  @override
  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed}) async {
    assert(_formBone != null);
    _formBone.submit(() async {
      final res = await onSubmit();
      return res == ButtonState.disabled ? FieldState.completed : FieldState.active;
    });

  }

  @override
  Future<void> inFieldState(FieldState state) async {
    switch (state) {
      case FieldState.active:
        addState(ButtonState.enabled);
        break;
      case FieldState.working:
        addState(ButtonState.working);
        break;
      case FieldState.completed:
        addState(ButtonState.disabled);
        break;
    }
  }
}

class ButtonFieldShell extends StatefulWidget implements FieldShell {
  final ButtonFieldBone bone;

  final ButtonShield shield;
  final Widget child;

  const ButtonFieldShell({Key key,
    @required this.bone,
    this.shield: const ButtonShield(), this.child,
  }) : super(key: key);

  @override
  _ButtonFieldShellState createState() => _ButtonFieldShellState();
}

class _ButtonFieldShellState extends State<ButtonFieldShell> with FieldStateMixin {
  FormBone _formBone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formBone = FormBone.of(context);
    assert(_formBone != null);
    widget.bone.formBone = _formBone;
  }

  @override
  void didUpdateWidget(ButtonFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      oldWidget.bone._formBone = null;
      widget.bone._formBone = _formBone;
    }
  }

  @override
  void dispose() {
    widget.bone.formBone = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ButtonShell(
      bone: widget.bone,
      shield: widget.shield,
      child: widget.child,
    );
  }
}
