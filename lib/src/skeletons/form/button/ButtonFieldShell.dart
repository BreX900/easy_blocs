import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/form/FormSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/button/ButtonFieldBone.dart';
import 'package:easy_blocs/src/skeletons/button/ButtonShell.dart';
import 'package:flutter/material.dart';


class ButtonFieldShell<B extends ButtonFieldBone> extends StatefulWidget {
  final FormSkeleton skeleton;
  final B bone;

  final Widget child;

  const ButtonFieldShell({Key key,
    this.skeleton, this.bone,
    this.child,
  }) : super(key: key);

  @override
  _ButtonFieldShellState<B> createState() => _ButtonFieldShellState<B>();
}

class _ButtonFieldShellState<B extends ButtonFieldBone> extends State<ButtonFieldShell<B>> {
  FormSkeleton _skeleton;
  B _bone;

  @override
  void initState() {
    super.initState();
    _bone = widget.bone??BoneProvider.of<B>(context);
    assert(_bone != null);
    _skeleton = widget.skeleton??BoneProvider.of<FormSkeleton>(context);
    assert(_skeleton != null);
    _skeleton.addButton(_bone);
  }

  @override
  void dispose() {
    _skeleton.removeButton(_bone);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return ButtonShell(
      bone: _bone,
      child: widget.child,
    );
  }
}