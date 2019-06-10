import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';


// TODO: Separare il checker dal controller. Il controller dovrà ereditare da CacheSubject e mixare con il checker
abstract class Checker<V, E> extends FingerNode implements CheckerRule<E> {
  final CacheSubject<DataField> _controller;

  /// [FocusHandlerRule] manages the next focus
  Checker({@required Hand hand, DataField update: const DataField(),
  }) : this._controller = CacheSubject.seeded(update), super(hand: hand);

  Stream<DataField> get outData => _controller.stream;

  DataField get data => _controller.value;
  String get text => data.text;
  V get value;

  void add(DataField data) => _controller.add(data);
  void addError(E error) => _controller.addError(error);

  Future<void> close() async {
    focusNode.dispose();
    await _controller.close();
  }

  /// Return null if pass check
  E validate(String str);

  final int maxLength = null;
  //final int minLength = null;
}


abstract class CheckerRule<E> implements FingerNode {
  Stream<DataField> get outData;

  void add(DataField data);

  E validate(String value);

  List<TextInputFormatter> get inputFormatters;

  int get maxLength;
  //int get minLength;
}


class DataField {
  final String text;
  final bool obscureText;

  const DataField({this.text, this.obscureText: false}) : assert(obscureText != null);

  copyWith({String text, bool obscureText}) {
    return DataField(
      text: text??this.text,
      obscureText: obscureText??this.obscureText,
    );
  }
}

