import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FocuserSkeleton extends Skeleton implements FocuserBone {
  final List<FocusNode> _pointsOfFocus = [];

  FocusScopeNode focusScope;

  FocuserSkeleton([this.focusScope]);

  void addPointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.add(pointOfFocus);
    if (_pointsOfFocus.length == 1)
      focusScope.requestFocus(pointOfFocus);
  }

  void removePointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.remove(pointOfFocus);
  }

  @override
  Future<void> nextFocus(FocusNode pointOfFocus) async {
    final nextPoint = _pointsOfFocus[_pointsOfFocus.indexOf(pointOfFocus)+1];

    if (nextPoint != null)
      Future.delayed(Duration(milliseconds: 500), () => focusScope.requestFocus(nextPoint));
  }
}


abstract class FocuserBone extends Bone {
  void addPointOfFocus(FocusNode pointOfFocus);

  void removePointOfFocus(FocusNode pointOfFocus);

  Future<void> nextFocus(FocusNode pointOfFocus);

  factory FocuserBone.of(BuildContext context) => BoneProvider.of(context);
}


abstract class FocusShell implements StatefulWidget {
  FocuserBone get mapFocusBone;
  FocusNode get focusNode;
}

mixin FocusShellStateMixin<WidgetType extends FocusShell> on State<WidgetType> {
  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;
  FocuserBone _mapFocusBone;
  FocuserBone get mapFocusBone => _mapFocusBone;

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
    _mapFocusBone?.removePointOfFocus(_focusNode);
    super.dispose();
  }

  void _updateFocus() {
    if (widget.focusNode == null && _focusNode == null)
      return;

    final automaticFocus = widget.mapFocusBone ?? BoneProvider.of<FocuserBone>(context);
    assert(automaticFocus != null);

    if (_mapFocusBone == automaticFocus && _focusNode == widget.focusNode)
      return;
    if (_focusNode != null) {
      _mapFocusBone.removePointOfFocus(_focusNode);
    }
    _focusNode = widget.focusNode;
    _mapFocusBone.addPointOfFocus(_focusNode);
  }

  void nextFocus() {
    if (mapFocusBone != null)
      mapFocusBone.nextFocus(focusNode);
  }
}


