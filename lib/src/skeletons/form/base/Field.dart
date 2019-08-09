import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:flutter/material.dart';


class FieldSheet<V> {
  final V value;

  const FieldSheet({this.value});

  FieldSheet<V> copyWith({
    V value,
  }) {
    return FieldSheet(
      value: value??this.value,
    );
  }

  bool valueIsEqualTo(value) {
    return value is V && this.value == value;
  }

  @override
  String toString() => "FieldSheet<$V>(value: $value)";
}


abstract class FieldBone<V> extends Bone implements ChangeNotifier {
  V value;

  FieldError validator(V value);
  void onSaved(V value);
}


abstract class FieldSkeleton<V> extends ChangeNotifier implements FieldBone<V>, Skeleton {
  final List<FieldValidator<V>> validators;

  FieldSkeleton({
    V value,
    List<FieldValidator<V>> validators,
  }) : _value = value, this.validators = validators??[], assert(validators != null);

  V _value;
  V get value => _value;
  set value(V value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  @override
  FieldError validator(V value) {
    for (var validator in validators) {
      final error = validator(value);
      if (error != null)
        return error;
    }
    return null;
  }

  void onSaved(V value) {
    this.value = value;
  }
  @protected
  Future<void> notifyListeners() async => super.notifyListeners();
}


class ListenerBuilder extends StatefulWidget {
  final ChangeNotifier notifier;
  final WidgetBuilder builder;

  const ListenerBuilder(this.builder, {Key key,
    @required this.notifier,
  }) :
        assert(builder != null),
        assert(notifier != null),
        super(key: key);

  @override
  _ListenerBuilderState createState() => _ListenerBuilderState();
}

class _ListenerBuilderState extends State<ListenerBuilder> {
  ChangeNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier;
    _notifier.addListener(_listener);
  }

  @override
  void didUpdateWidget(ListenerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notifier != widget.notifier) {
      _notifier.removeListener(_listener);
      _notifier = widget.notifier;
      _notifier.addListener(_listener);
    }
  }

  @override
  void dispose() {
    _notifier?.removeListener(_listener);
    super.dispose();
  }

  void _listener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}


//class FieldBuilder<B extends FieldBone, S extends FieldSheet> extends BoneBuilder<B, S> {
//
//  FieldBuilder(Widget builder(BuildContext context, B fieldBone, S sheet), {
//    S initialData, bool forceUpdate: false,
//  }) : super((context, bone, value, state) => builder(context, bone, value),
//    outer: (_, fieldBone) => fieldBone.outFieldSheet,
//    initialData: initialData, forceUpdate: forceUpdate,
//  );
//}



typedef InputDecoration FieldDecorator<S>(S fieldBone);
typedef FieldError FieldValidator<V>(V value);
typedef Translations FieldErrorTranslator(FieldError error);

TranslationsConst byPassNoisy(FieldError error) {
  return error == null ? null : TranslationsConst(en: error.code);
}

class FieldError {
  static const undefined = FieldError("NULL");
  static const invalid = FieldError("INVALID");

  final String code;
  final Object data;

  const FieldError(this.code, [this.data]);
}


class ValueFieldValidator {
  static FieldError notUndefined(value) {
    if (value == null)
      return FieldError.undefined;
    return null;
  }
}