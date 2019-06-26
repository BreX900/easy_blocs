import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:flutter/widgets.dart';


typedef Future<V> Submitter<V>();
typedef Future<bool> Validator();


class FormHandler {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final List<SubmitController> _submitControllers = [];

  final List<Validator> _preValidators, _postValidators;

  FormHandler({
    List<Validator> preValidators, List<Validator> postValidators,
  }) : this._preValidators = preValidators??[], this._postValidators = postValidators??[];

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
        await submitter();
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
    return formKey.currentState.validate() && await _validate(_preValidators);
  }

  /// Validate Fields after save values
  Future<bool> postValidate() => _validate(_postValidators);

  void addPostValidator(Validator validator) => _postValidators.add(validator);
  void addPreValidator(Validator validator) => _preValidators.add(validator);

  Future<bool> _validate(List<Validator> validators) async {
    for (var validator in validators) {
      if (!await validator())
    return false;
  }
    return true;
  }
  
  addSubmitController(SubmitController controller) {
    _submitControllers.add(controller);
  }
}
