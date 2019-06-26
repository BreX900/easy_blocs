import 'package:easy_blocs/src/checker/controllers/FormHandler.dart';
import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


/// Must call [formHandler.dispose()]
@deprecated
mixin MixinFormHandler implements FormHandler {
  FormHandler get formHandler;

  void dispose() {
    formHandler.dispose();
  }

  GlobalKey<FormState> get formKey => formHandler.formKey;

  @override
  addSubmitController(SubmitController controller) {
    return formHandler.addSubmitController(controller);
  }

  /// Must not override this method
  Future<void> submit<V>(Submitter<V> onSubmit) async {
    await formHandler.submit(onSubmit);
  }
  /// Validate Fields before save values
  @mustCallSuper
  Future<bool> preValidate() async {
    return await formHandler.preValidate();
  }

  /// Validate Fields after save values
  Future<bool> postValidate() async {
    return await formHandler.postValidate();
  }
}