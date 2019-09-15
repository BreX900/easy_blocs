import 'dart:async';

import 'package:easy_blocs/src/skeletons/button/Button.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class ButtonFieldBone extends ButtonBone {
  set formBone(FormBone formBone);
  FormBone _formBone;
}

class ButtonFieldSkeleton extends ButtonSkeleton implements ButtonFieldBone {
  FormBone _formBone;

  set formBone(FormBone formBone) => _formBone = formBone;

  @override
  Future<void> onPressed({AsyncCallback starter, AsyncCallback completed}) async {
    assert(_formBone != null);
    if (!await _formBone.validation()) {
      inState(true);
      return;
    }
    _formBone.save();
    inState(await onSubmit());
  }
}

class ButtonFieldShell extends StatefulWidget {
  final ButtonFieldBone bone;

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

  const ButtonFieldShell({
    Key key,
    @required this.bone,
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
  }) : super(key: key);

  @override
  _ButtonFieldShellState createState() => _ButtonFieldShellState();
}

class _ButtonFieldShellState extends State<ButtonFieldShell> {
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
      isEnableSafeArea: true,
      buttonDesign: widget.buttonDesign,
      textTheme: widget.textTheme,
      textColor: widget.textColor,
      disabledTextColor: widget.disabledTextColor,
      color: widget.color,
      disabledColor: widget.disabledColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      splashColor: widget.splashColor,
      shape: widget.shape,
      clipBehavior: widget.clipBehavior,
      focusNode: widget.focusNode,
      child: widget.child,
    );
  }
}
