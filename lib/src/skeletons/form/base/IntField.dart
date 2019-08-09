import 'package:easy_blocs/src/skeletons/form/base/Field.dart';


abstract class IntFieldBone extends FieldBone<int> {}


class IntFieldSkeleton extends FieldSkeleton<int> implements IntFieldBone {
  IntFieldSkeleton({
    int value,
    List<FieldValidator<int>> validators,
  }) : super(
    value: value,
    validators: validators??[IntFieldValidator.undefined],
  );

  static String writer(int value) => value.toString();
  static int reader(String value) => int.tryParse(value);
}


class IntFieldValidator {
  static FieldError undefined(int num) {
    if (num == null)
      return IntFieldError.undefined;
    return null;
  }

  static FieldValidator<int> max(int max) {
    assert(max != null);
    return (int value) {
      if (value > max)
        return IntFieldError.min;
      return null;
    };
  }

  static FieldValidator<int> min(int min) {
    assert(min != null);
    return (int value) {
      if (value < min)
        return IntFieldError.min;
      return null;
    };
  }
}

class IntFieldError {
  static const undefined = FieldError.undefined;
  static const notValid = FieldError("NOT_VALID");
  static const max = FieldError("MAX");
  static const min = FieldError("MIN");
}


//class IntFieldShell extends StatefulWidget implements FocusShell {
//  final IntFieldBone fieldBone;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  final FieldErrorTranslator nosy;
//  final InputDecoration decoration;
//
//  const IntFieldShell({Key key,
//    @required this.fieldBone,
//    this.mapFocusBone, this.focusNode,
//
//    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
//  }) :
//        assert(fieldBone != null),
//        assert(decoration != null), super(key: key);
//
//  @override
//  _IntFieldShellState createState() => _IntFieldShellState();
//}
//
//class _IntFieldShellState extends State<IntFieldShell> with FocusShellStateMixin {
//  ValueChanged<int> _setState;
//  int _value;
//
//  @override
//  void initState() {
//    super.initState();
//    _value = widget.fieldBone.value;
//  }
//
//  @override
//  void didUpdateWidget(IntFieldShell oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (_value != widget.fieldBone.value)
//      _setState(_value);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return FormField<int>(
//      initialValue: _value,
//      onSaved: widget.fieldBone.onSaved,
//      validator: (value) => widget.nosy(widget.fieldBone.validator(value))?.text,
//      builder: (FormFieldState<int> state) {
//        _setState = state.didChange;
//
//        return TextField(
//          focusNode: focusNode,
//          onChanged: (text) {
//            // ignore: invalid_use_of_protected_member
//            state.setValue(int.tryParse(text));
//          },
//          onSubmitted: (_) => nextFocus(),
//          decoration: widget.decoration.copyWith(
//            errorText: state.errorText,
//          ),
//        );
//      },
//    );
//  }
//}