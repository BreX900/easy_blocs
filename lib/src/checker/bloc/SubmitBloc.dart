import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/checker/controllers/FormHandler.dart';
import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';


typedef void GetterFocusManager(BuildContext context);


abstract class SubmitBloc implements Bloc, FormHandler, Hand {
  final Hand _hand;
  final FormHandler _formHandler;

  SubmitBloc({
    bool state: true, Hand hand, FormHandler formHandler
  }) : assert(state != null),
        this._hand = hand??Hand(), this._formHandler = formHandler??FormHandler();

  @mustCallSuper
  void dispose() {
    _formHandler.dispose();
    _hand.dispose();
  }

  GlobalKey<FormState> get formKey => _formHandler.formKey;

  @override
  addSubmitController(SubmitController controller) {
    return _formHandler.addSubmitController(controller);
  }

  /// Must not override this method
  Future<void> submit(Submitter onSubmit) async {
    return await _formHandler.submit(onSubmit);
  }
  /// Validate Fields before save values
  @mustCallSuper
  Future<bool> preValidate() async {
    return await _formHandler.preValidate();
  }

  /// Validate Fields after save values
  Future<bool> postValidate() async {
    return await _formHandler.postValidate();
  }

  @override
  void addFinger(Finger finger) {
    _hand.addFinger(finger);
  }

  bool nextFinger(BuildContext context, Finger finger) {
    return _hand.nextFinger(context, finger);
  }
}

