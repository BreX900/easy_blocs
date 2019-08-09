//import 'package:easy_blocs/src/skeletons/form/dropdown_button/OptionsFieldBone.dart';
//import 'package:easy_blocs/src/skeletons/form/dropdown_button/OptionsFieldSheet.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBuilder.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldSkeleton.dart';
//
//
//class OptionsFieldSkeleton<V> extends FieldSkeleton<V, OptionsFieldSheet<V>>
//    implements OptionsFieldBone<V> {
//
//  OptionsFieldSkeleton({
//    OptionsFieldSheet<V> initialValue: const OptionsFieldSheet(),
//    List<FieldValidator<V>> validators: const [],
//  }) : super(
//    initialValue: initialValue,
//    validators: validators,
//  );
//
//  V get value => sheet.value;
//
//  @override
//  void onSaved(V value) {
//    controller.add(sheet.copyWith(
//      value: value,
//    ));
//  }
//}


