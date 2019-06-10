import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/widget/SubmitButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


typedef void GetterFocusManager(BuildContext context);


abstract class SubmitBloc<U> extends Hand implements Bloc, SubmitController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPerform = false;

  @mustCallSuper
  void dispose() {
    submitController.close();
  }

  final Completer<U> _completer = Completer();
  Future<U> get result => _completer.future;

  @protected
  CacheSubject<bool> submitController;
  Stream<bool> get outSubmit => submitController.stream;

  /// Must not override this method
  Future<void> submit() async {
    if (!submitController.value) return;
    submitController.add(false);
    if (await preValidate()) {
      formKey.currentState.save();
      if (await postValidate()) {
        final res = await signer();
        if (res != null) {
          _completer.complete(res);
          return;
        }
      }
    }
    submitController.add(true);
  }
  /// Validate Fields before save values
  @mustCallSuper
  Future<bool> preValidate() async {
    return formKey.currentState.validate();
  }

  /// Validate Fields after save values
  Future<bool> postValidate() async {
    return true;
  }

  @protected
  Future<U> signer();

  bool nextFinger(BuildContext context, Finger finger) {
    if (!super.nextFinger(context, finger)) {
      submit();
      return false;
    }
    return true;
  }

  SubmitBloc({
    bool state: true,
  }) : assert(state != null), this.submitController = CacheSubject.seeded(state);
}

