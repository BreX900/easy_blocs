import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MapFocusSkeleton extends Skeleton implements MapFocusBone {
  final List<FocusNode> _pointsOfFocus = [];

  FocusScopeNode focusScope;

  MapFocusSkeleton([this.focusScope]);

  void addPointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.add(pointOfFocus);
    if (_pointsOfFocus.length == 1)
      focusScope.requestFocus(pointOfFocus);
  }

  void removePointOfFocus(FocusNode pointOfFocus) {
    _pointsOfFocus.remove(pointOfFocus);
  }

  @override
  void nextFocus(FocusNode pointOfFocus) {
    final nextPoint = _pointsOfFocus[_pointsOfFocus.indexOf(pointOfFocus)+1];

    if (nextPoint != null)
      Future.delayed(Duration(milliseconds: 500), () => focusScope.requestFocus(nextPoint));
  }
}


abstract class MapFocusBone extends Bone {
  void addPointOfFocus(FocusNode pointOfFocus);

  void removePointOfFocus(FocusNode pointOfFocus);

  void nextFocus(FocusNode pointOfFocus);
}



abstract class FocusShell implements StatefulWidget {
  MapFocusBone get mapFocusBone;
  FocusNode get focusNode;
}

mixin FocusShellStateMixin<WidgetType extends FocusShell> on State<WidgetType> {
  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;
  MapFocusBone _mapFocusBone;
  MapFocusBone get mapFocusBone => _mapFocusBone;

  VoidCallback focusListener;

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

    final automaticFocus = widget.mapFocusBone ?? BoneProvider.of<MapFocusBone>(context);
    assert(automaticFocus != null);

    if (_mapFocusBone == automaticFocus && _focusNode == widget.focusNode)
      return;
    if (_focusNode != null) {
      _mapFocusBone.removePointOfFocus(_focusNode);
      if (focusListener != null)
        _focusNode.removeListener(focusListener);
    }
    _focusNode = widget.focusNode;
    _mapFocusBone.addPointOfFocus(_focusNode);
    if (focusListener != null)
      _focusNode.addListener(focusListener);
  }

  void nextFocus() {
    if (mapFocusBone != null)
      mapFocusBone.nextFocus(focusNode);
  }
}


