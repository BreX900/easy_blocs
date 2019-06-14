import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FormHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


class SubmitController implements Finger {
  final AsyncCallback onSubmit;

  SubmitController({
    @required Submitter onSubmit, @required FormHandler handler, Hand hand,
  }) : this.onSubmit = (() async => await handler.submit(onSubmit)) {
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


