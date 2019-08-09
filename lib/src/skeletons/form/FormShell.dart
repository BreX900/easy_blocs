import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/widgets.dart';


class FormShell<V> extends StatefulWidget {
  final Stream<V> outEvent;
  final ValueChanged<V> eventListener;

  final List<FieldBone> fieldBones;

  final Widget child;

  FormShell({Key key,
    this.outEvent, this.eventListener,
    this.fieldBones: const [],
    @required this.child,
  }) : super(key: key);

  @override
  _FormShellState createState() => _FormShellState();
}

class _FormShellState extends State<FormShell> {
  StreamSubscription _subscription;
  MapFocusSkeleton _mapFocusBone;

  @override
  void initState() {
    super.initState();
    _mapFocusBone = MapFocusSkeleton();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapFocusBone.focusScope = FocusScope.of(context);
  }

  @override
  void didUpdateWidget(FormShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.outEvent != oldWidget.outEvent || widget.eventListener != oldWidget.eventListener) {
      _closeEvent();
      _initEvent();
    }
  }

  @override
  void dispose() {
    _closeEvent();
    super.dispose();
  }

  void _initEvent() {
    _subscription = widget.outEvent?.listen(widget.eventListener);
  }
  void _closeEvent() {
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return BoneProviderTree(
      boneProviders: [(_mapFocusBone as MapFocusBone), ...widget.fieldBones].map((bone) => BoneProvider.tree(bone)).toList(),
      child: Form(
        child: widget.child,
      ),
    );
  }
}





