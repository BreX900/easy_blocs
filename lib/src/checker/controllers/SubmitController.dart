import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FormHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


class SubmitController<V> implements Finger {
  final Submitter<V> _onSubmit;
  final FormHandler _handler;
  ValueChanged<V> solver = (_) {};

  SubmitController({
    @required Submitter<V> onSubmit, @required FormHandler handler, Hand hand,
  }) : this._onSubmit = onSubmit, this._handler = handler {
    handler.addSubmitController(this);
    hand?.addFinger(this);
  }

  @mustCallSuper
  void dispose() {
    _submitController.close();
  }

  CacheSubject<SubmitData> _submitController = CacheSubject.seeded(SubmitData(event: SubmitEvent.WAITING));
  Stream<SubmitData> get outData => _submitController.stream;

  SubmitData get data => _submitController.value;

  addData(SubmitData data) {
    _submitController.add(data);
  }

  addEvent(SubmitEvent event) {
    _submitController.add(data.copyWith(error: event));
  }

  Future<void> onSubmit() async {
    await _handler.submit(() async {
      final res = await _onSubmit();
      solver(res);
      return res;
    });
  }

  @override
  void acquire(BuildContext context) => onSubmit();
}


class SubmitData {
  final SubmitEvent event;

  SubmitData({this.event});

  SubmitData copyWith({SubmitEvent error}) {
    return SubmitData(
      event: error,
    );
  }
}


enum SubmitEvent {
  WAITING, WORKING, COMPLETE,
}


