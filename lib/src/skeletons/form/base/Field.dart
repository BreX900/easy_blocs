//import 'dart:async';
//
//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/translator/TranslationsModel.dart';
//import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';
//
//abstract class FieldShell implements StatefulWidget {
//  FieldBone get bone;
//}
//mixin FieldStateMixin<WidgetType extends FieldShell> on State<WidgetType> {
//  FormSkeleton _formBone;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    final newFormBone = FormShell.of(context);
//    if (_formBone != newFormBone) {
//      _formBone?.removeField(widget.bone);
//      _formBone.addField(widget.bone);
//    }
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.bone != oldWidget.bone) {
//      _formBone.removeField(oldWidget.bone);
//      _fomrBone.addField(widget.bone);
//    }
//  }
//
//  @override
//  void dispose() {
//    _formBone.removeField(widget.bone);
//    super.dispose();
//  }
//}
//
//
//enum FieldState {
//  active, working, completed,
//}
//
//
//abstract class FieldBone<V> extends Bone {
//  Future<bool> validation();
//  void save();
//}
//
//
//abstract class FieldSkeleton<V> extends Skeleton implements FieldBone<V> {
//  final List<FieldValidator<V>> validators;
//
//  FieldSkeleton({
//    V value,
//    List<FieldValidator<V>> validators,
//  }) : _value = value, this.validators = validators??[];
//
//  V get tmpValue;
//  Future<void> inTmpValue(V value);
//  Future<void> inState(FieldState state);
//  Future<void> inError(FieldError error);
//
//  V _value;
//  V get value => _value;
//  set value(V value) {
//    if (_value != value) {
//      _value = value;
//      inTmpValue(_value);
//    }
//  }
//
//  @override
//  Future<bool> validation() {
//    return inState(FieldState.working).then((_) async {
//      for (var validator in validators) {
//        final error = await validator(tmpValue);
//        if (error != null) {
//          inError(error);
//          return false;
//        }
//      }
//      return true;
//    });
//  }
//  @override
//  void save() {
//    this.value = tmpValue;
//  }
//}
//
//
//
//
//abstract class ObservableListener<V> implements StatefulWidget {
//  Stream<V> get stream;
//}
//
//mixin ObservableListenerStateMixin<WidgetType extends ObservableListener<V>, V> on State<WidgetType> {
//
//  StreamSubscription _subscription;
//
//  @override
//  void initState() {
//    super.initState();
//    if (widget.stream is ValueObservable)
//      initStreamValue((widget.stream as ValueObservable).value);
//    _initListener();
//  }
//
//  @override
//  void didUpdateWidget(WidgetType oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.stream != oldWidget.stream) {
//      _subscription.cancel();
//      if (widget.stream is ValueObservable)
//        streamListener((widget.stream as ValueObservable).value);
//      _initListener();
//    }
//  }
//
//  @override
//  void dispose() {
//    _subscription.cancel();
//    super.dispose();
//  }
//
//  void _initListener() {
//    assert(widget.stream != null);
//    _subscription = widget.stream.listen(streamListener);
//  }
//  void initStreamValue(V event) {}
//  void streamListener(V event);
//}
//
////class FieldBuilder<B extends FieldBone, S extends FieldSheet> extends BoneBuilder<B, S> {
////
////  FieldBuilder(Widget builder(BuildContext context, B fieldBone, S sheet), {
////    S initialData, bool forceUpdate: false,
////  }) : super((context, bone, value, state) => builder(context, bone, value),
////    outer: (_, fieldBone) => fieldBone.outFieldSheet,
////    initialData: initialData, forceUpdate: forceUpdate,
////  );
////}
//
//
//
//typedef InputDecoration FieldDecorator<S>(S fieldBone);
//typedef Future<FieldError> FieldValidator<V>(V value);
//typedef Translations FieldErrorTranslator(FieldError error);
//
//TranslationsConst byPassNoisy(FieldError error) {
//  return error == null ? null : TranslationsConst(en: error.code);
//}
//
//class FieldError {
//  static const undefined = FieldError("NULL");
//  static const invalid = FieldError("INVALID");
//
//  final String code;
//  final Object data;
//
//  const FieldError(this.code, [this.data]);
//}
//
//
//class ValueFieldValidator {
//  static FieldError notUndefined(value) {
//    if (value == null)
//      return FieldError.undefined;
//    return null;
//  }
//}


//class ListenerBuilder extends StatefulWidget {
//  final ChangeNotifier notifier;
//  final WidgetBuilder builder;
//
//  const ListenerBuilder(this.builder, {Key key,
//    @required this.notifier,
//  }) :
//        assert(builder != null),
//        assert(notifier != null),
//        super(key: key);
//
//  @override
//  _ListenerBuilderState createState() => _ListenerBuilderState();
//}
//
//class _ListenerBuilderState extends State<ListenerBuilder> {
//  ChangeNotifier _notifier;
//
//  @override
//  void initState() {
//    super.initState();
//    _notifier = widget.notifier;
//    _notifier.addListener(_listener);
//  }
//
//  @override
//  void didUpdateWidget(ListenerBuilder oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.notifier != widget.notifier) {
//      _notifier.removeListener(_listener);
//      _notifier = widget.notifier;
//      _notifier.addListener(_listener);
//    }
//  }
//
//  @override
//  void dispose() {
//    _notifier?.removeListener(_listener);
//    super.dispose();
//  }
//
//  void _listener() => setState(() {});
//
//  @override
//  Widget build(BuildContext context) {
//    return widget.builder(context);
//  }
//}