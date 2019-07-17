import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
import 'package:flutter/widgets.dart';


abstract class FieldBone<V, S extends FieldSheet> implements Bone {
  Stream<S> get outFieldSheet;

  void onFieldSubmitted(V value);
  void onSaved(V value);
  String validator(V value);

  FocusNode get focusNode;
}