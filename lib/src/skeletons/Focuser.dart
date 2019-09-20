import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FocuserSkeleton extends Skeleton implements FocuserBone {
  final List<FocusNode> _pointsOfFocus = [];
  final bool autoFocus;

  FocusScopeNode focusScope;

  FocuserSkeleton({this.focusScope, this.autoFocus: false});

  void addPointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.add(pointOfFocus);
    if (_pointsOfFocus.length == 1 && autoFocus) focusScope.requestFocus(pointOfFocus);
  }

  void removePointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.remove(pointOfFocus);
  }

  @override
  Future<void> nextFocus(FocusNode pointOfFocus) async {
    final indexNext = _pointsOfFocus.indexOf(pointOfFocus) + 1;
    
    if (indexNext >= _pointsOfFocus.length) return;

    final nextPoint = _pointsOfFocus[indexNext];

    if (nextPoint != null)
      Future.delayed(Duration(milliseconds: 500), () => focusScope.requestFocus(nextPoint));
  }
}

abstract class FocuserBone extends Bone {
  void addPointOfFocus(FocusNode pointOfFocus);

  void removePointOfFocus(FocusNode pointOfFocus);

  Future<void> nextFocus(FocusNode pointOfFocus);

  factory FocuserBone.of(BuildContext context, [bool allowNull = false]) =>
      BoneProvider.of(context, allowNull);
}

abstract class FocusShell implements StatefulWidget {
  FocuserBone get mapFocusBone;
  FocusNode get focusNode;
}

mixin FocusShellStateMixin<WidgetType extends FocusShell> on State<WidgetType> {
  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;
  FocuserBone _focuser;
  FocuserBone get focuser => _focuser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFocus();
  }

  @override
  void didUpdateWidget(WidgetType oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mapFocusBone != oldWidget.mapFocusBone || widget.focusNode != oldWidget.focusNode)
      _updateFocus();
  }

  @override
  void dispose() {
    _focuser?.removePointOfFocus(_focusNode);
    super.dispose();
  }

  void _updateFocus() {
    if (widget.focusNode == null && _focusNode == null) return;

    final newFocuser = widget.mapFocusBone ?? BoneProvider.of<FocuserBone>(context);
    assert(newFocuser != null);

    if (_focuser == newFocuser && _focusNode == widget.focusNode) return;
    if (_focusNode != null) {
      _focuser.removePointOfFocus(_focusNode);
    }
    _focusNode = widget.focusNode;
    _focuser = newFocuser;
    _focuser.addPointOfFocus(_focusNode);
  }

  void nextFocus() {
    if (focusNode != null) focuser.nextFocus(focusNode);
  }
}

class FocuserPocket {
  HashMap<Object, FocusNode> _focus = HashMap();

  FocuserPocket();

  FocusNode operator [](Object object) {
    final focus = _focus[object];
    if (focus == null) {
      final tmpFocus = FocusNode();
      _focus[object] = tmpFocus;
      return tmpFocus;
    }
    return focus;
  }

  void dispose() => _focus = null;
}
