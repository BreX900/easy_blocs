import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:easy_blocs/src/skeletons/form/FormSkeleton.dart';
import 'package:easy_blocs/src/skeletons/form/dropdown_button/DropdownButtonFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/dropdown_button/DropdownButtonFieldSheet.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldShell.dart';
import 'package:flutter/material.dart';


class DropdownButtonShell<V> extends StatefulWidget {
  final FormSkeleton skeleton;
  final DropdownButtonFieldBone<V> bone;

  final TwoBuilder<DropdownButtonSheet<V>, DropdownButtonFieldBone<V>, InputDecoration> decorator;

  const DropdownButtonShell({Key key,
    this.skeleton, this.bone,
    this.decorator: _decorator,
  }) : super(key: key);

  static InputDecoration _decorator(DropdownButtonSheet sheet, DropdownButtonFieldBone bone) => null;

  @override
  _DropdownButtonShellState<V> createState() => _DropdownButtonShellState<V>();
}

class _DropdownButtonShellState<V> extends State<DropdownButtonShell<V>> {
  FormSkeleton _skeleton;
  DropdownButtonFieldBone<V> _bone;
  DropdownButtonSheet<V> _sheet;

  @override
  void initState() {
    super.initState();
    _bone = widget.bone??BoneProvider.of<DropdownButtonFieldBone<V>>(context);
    assert(_bone != null);
    _skeleton = widget.skeleton??BoneProvider.of<FormSkeleton>(context);
    assert(_skeleton != null);
    _skeleton.addField(_bone);
  }

  @override
  void dispose() {
    _skeleton.removeField(_bone);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: _sheet.value,
      items: _sheet.items,
      onSaved: _bone.onSaved,
      validator: _bone.validator,
      decoration: widget.decorator(_sheet, _bone),
    );
  }
}