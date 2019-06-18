import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:flutter/widgets.dart';


typedef Future<V> Submitter<V>();
typedef Future<bool> Validator();


class FormHandler {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final List<SubmitController> _submitControllers = [];

  final Validator _preValidator, _postValidator;

  FormHandler({
    Validator preValidator, Validator postValidator,
  }) : this._preValidator = preValidator, this._postValidator = postValidator;

  void dispose() {
    _submitControllers.forEach((controller) => controller.dispose());
  }

  Future<void> submit<V>(Submitter<V> submitter) async {
    if (_submitControllers.any((controller) => controller.data.event != SubmitEvent.WAITING))
      return;
    await _addEvent(SubmitEvent.WORKING);
    if (await preValidate()) {
      formKey.currentState.save();
      if (await postValidate()) {
        final res = await submitter();
        _addEvent(res == null ? SubmitEvent.WAITING : SubmitEvent.COMPLETE);
        return;
      }
    }
    await _addEvent(SubmitEvent.WAITING);
    return;
  }

  Future<void> _addEvent(SubmitEvent event) async {
    _submitControllers.forEach((controller) => controller.addEvent(event));
  }

  /// Validate Fields before save values
  @mustCallSuper
  Future<bool> preValidate() async {
    return formKey.currentState.validate() && (_preValidator == null || await _preValidator());
  }

  /// Validate Fields after save values
  Future<bool> postValidate() async {
    return (_postValidator == null || await _postValidator());
  }
  
  addSubmitController(SubmitController controller) {
    _submitControllers.add(controller);
  }
}
