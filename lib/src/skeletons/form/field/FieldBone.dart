//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
//
//
//abstract class FieldBone<V, S extends FieldSheet> implements Bone {
//  Stream<S> get outFieldSheet;
//  S get sheet;
//  V get value => sheet.value;
//
//  void onSaved(V value);
//  FieldError validator(V value);
//}