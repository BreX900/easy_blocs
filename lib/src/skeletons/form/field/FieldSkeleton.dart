import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldSheet.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


abstract class FieldSkeleton<V, S extends FieldSheet> extends Skeleton implements FieldBone<V, S> {
  final List<FormFieldValidator<V>> validators;

  final BehaviorSubject<S> controller;

  final FocusNode focusNode = FocusNode();

  FieldSkeleton({
    S initialValue,
    this.validators: const [],
  }) : this.controller = BehaviorSubject.seeded(initialValue);

  S get sheet => controller.value;

  @override
  void onFieldSubmitted(V value) {}

  @override
  Stream<S> get outFieldSheet => controller.stream;

  @override
  String validator(V value) {
    for (var validator in validators) {
      final error = validator(value);
      if (error != null)
        return error;
    }
    return null;
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}