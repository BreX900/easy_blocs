import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:rational/rational.dart';



abstract class PriceFieldBone extends FieldBone<Rational> {}


class PriceFieldSkeleton extends FieldSkeleton<Rational> implements PriceFieldBone {
  PriceFieldSkeleton({
    Rational value,
    List<FieldValidator<int>> validators,
  }) : super(
    value: value,
    validators: validators??[PriceFieldValidator.undefined],
  );

  static String writer(Rational value) {
    //print(value.toStringAsPrecision(2));
    return value.toStringAsPrecision(2);
  }
  static Rational reader(String value) {
    return Rational.parse(value);
  }
}


class PriceFieldValidator {
  static FieldError undefined(Rational num) {
    if (num == null)
      return PriceFieldError.undefined;
    return null;
  }
}

class PriceFieldError {
  static const undefined = FieldError.undefined;
}


//class PriceFieldShell extends StatefulWidget implements FocusShell {
//  final PriceFieldBone bone;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  final FieldErrorTranslator nosy;
//  final InputDecoration decoration;
//
//  const PriceFieldShell({Key key,
//    @required this.bone,
//    this.mapFocusBone, this.focusNode,
//
//    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
//  }) :
//        assert(bone != null),
//        assert(decoration != null), super(key: key);
//
//  @override
//  _PriceFieldShellState createState() => _PriceFieldShellState();
//}
//
//class _PriceFieldShellState extends State<PriceFieldShell> with FocusShellStateMixin {
//  static final _pattern = RegExp("[\,,\.]");
//
//
//  PriceFieldBone get bone => widget.bone;
//  PriceFieldSheet get sheet => bone.sheet;
//  Rational get value => sheet.value;
//
////  Rational _convert(String text) {
////    final numbers = text.split(_pattern);
////    if (numbers.length > 2)
////      return null;
////
////    final decimal = int.tryParse(numbers[0]);
////    if (decimal == null)
////      return null;
////
////    return
////    return (decimal*100) + (numbers.length > 1 ? int.tryParse(numbers[1])??0 : 0);
////  }
//
//  TextEditingController _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller = TextEditingController(text: sheet.value?.toStringAsPrecision(2));
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  bool _textListener() {
//    var index = _controller.text.indexOf(_pattern);
//    if (index == -1)
//      return true;
//    index = _controller.text.indexOf(_pattern, index+1);
//    if (index == -1)
//      return true;
//    _controller.value = _controller.value.copyWith(text: _controller.text.substring(0, index));
//    return false;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    assert(sheet != null);
//
//    return FormField<Rational>(
//      initialValue: bone.sheet.value,
//      onSaved: bone.onSaved,
//      validator: (value) => widget.nosy(bone.validator(value))?.text,
//      builder: (FormFieldState<Rational> state) {
//
//        return TextField(
//          controller: _controller,
//          focusNode: focusNode,
//          onChanged: (text) {
//            if (_textListener())
//              // ignore: invalid_use_of_protected_member
//              state.setValue(Rational.parse(text));
//          },
//          onSubmitted: (_) => nextFocus(),
//          decoration: widget.decoration.copyWith(
//            errorText: state.errorText,
//          ),
//          keyboardType: bone.keyboardType,
//        );
//      },
//    );
//  }
//}