import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


// TODO: Separare il checker dal controller. Il controller dovrà ereditare da CacheSubject e mixare con il checker
abstract class Checker<V, S> extends FingerNode implements CheckerRule<V, S> {
  final CacheSubject<DataField<V>> _controller;
  final Hand hand;

  /// [FocusHandlerRule] manages the next focus
  Checker({@required this.hand, DataField<V> update,
  }) : this._controller = CacheSubject.seeded(update??DataField<V>() ), super(hand: hand);

  Stream<DataField<V>> get outData => _controller.stream;

  DataField<V> get data => _controller.value;
  V get value => data.value;
  String get text => '${data.value}';

  void add(DataField<V> data) => _controller.add(data);

  void addError(Object error) => _controller.add(data.addError(error));

  Future<void> dispose() async {
    super.dispose();
    await _controller.close();
  }

  final int maxLength = null;

  final inputFormatters = null;

  Object validate(S val) => null;

  obscureText(bool obscureText) => add(data.copyWith(obscureText: obscureText));

  void nextFinger(BuildContext context) {
    hand.nextFinger(context, this);
  }
}


abstract class CheckerRule<V, S> implements FingerNode {
  Stream<DataField<V>> get outData;

  Object validate(S val);

  void onSaved(S val);

  List<TextInputFormatter> get inputFormatters;

  int get maxLength;

  obscureText(bool obscureText);

  void nextFinger(BuildContext context);
}


class DataField<V> {
  final Object error;
  final V value;
  final bool obscureText;

  const DataField({
    this.error, this.value, this.obscureText: false,
  }) : assert(obscureText != null);

  String get text => value == null ? null : value.toString();

  DataField<V> copyWith({V value, bool obscureText}) {
    return _copyWith(value: value, obscureText: obscureText);
  }
  DataField<V> addError(Object error) {
    return _copyWith(error: error);
  }

  DataField<V> _copyWith({Object error, V value, bool obscureText}) {
    return DataField(
      error: error,
      value: value??this.value,
      obscureText: obscureText??this.obscureText,
    );
  }
}
