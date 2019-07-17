import 'package:easy_blocs/src/skeletons/form/dropdown_button/DropdownButtonFieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/dropdown_button/DropdownButtonFieldSheet.dart';
import 'package:easy_blocs/src/skeletons/form/field/FieldSkeleton.dart';


class DropdownButtonFieldSkeleton<V>
    extends FieldSkeleton<V, DropdownButtonSheet<V>>
    implements DropdownButtonFieldBone<V> {

  V get value => sheet.value;

  @override
  void onSaved(V value) {
    controller.add(sheet.copyWith(
      value: value,
    ));
  }
}


