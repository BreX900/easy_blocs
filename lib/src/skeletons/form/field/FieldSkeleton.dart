//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//abstract class FieldSkeleton<V, S extends FieldSheet<V>> extends Skeleton implements FieldBone<V, S> {
//  final List<FieldValidator<V>> validators;
//
//  final BehaviorSubject<S> controller;
//
//  FieldSkeleton({
//    S initialValue,
//    this.validators: const [],
//  }) : assert(initialValue != null), this.controller = BehaviorSubject.seeded(initialValue);
//
//  S get sheet => controller.value;
//  set sheet(S sheet) => controller.add(sheet);
//
//  V get value => sheet.value;
//  set value(V value) => sheet = sheet.copyWith(value: value);
//
//  @override
//  Stream<S> get outFieldSheet => controller.stream;
//
//  @override
//  FieldError validator(V value) {
//    for (var validator in validators) {
//      final error = validator(value);
//      if (error != null)
//        return error;
//    }
//    return null;
//  }
//
//  void check(V value) {
//    if (value != null && this.sheet.value != value)
//      this.sheet = sheet.copyWith(value: value);
//  }
//
//  @override
//  void dispose() {
//    controller.close();
//    super.dispose();
//  }
//}
