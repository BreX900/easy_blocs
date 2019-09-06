import 'package:easy_blocs/src/skeletons/button/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IconButtonShell extends ButtonShellBuilder {
  final double iconSize;
  final EdgeInsets padding;
  final Alignment alignment;
  final Color color;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final Color disabledColor;
  final FocusNode focusNode;
  final String tooltip;
  final Widget icon;

  IconButtonShell({
    Key key,
    @required ButtonBone bone,
    this.iconSize: 24.0,
    this.padding: const EdgeInsets.all(8.0),
    this.alignment: Alignment.center,
    @required this.icon,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.focusNode,
    this.tooltip,
  }) : super(
            key: key,
            bone: bone,
            builder: ((BuildContext context, ButtonState state) {
              return IconButton(
                iconSize: iconSize,
                padding: padding,
                alignment: alignment,
                color: color,
                focusColor: focusColor,
                hoverColor: hoverColor,
                highlightColor: highlightColor,
                splashColor: splashColor,
                disabledColor: disabledColor,
                focusNode: focusNode,
                tooltip: tooltip,
                onPressed: state == ButtonState.enabled ? bone.pressed : null,
                icon: icon,
              );
            }));
}
