import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';


abstract class SpManager {
  Observable<Sp> get outSp;
  Sp get sp;

  Future<void> inContext(BuildContext context);
}


class SpController implements SpManager {
  Sp get _sp => _spController.value;

  void dispose() {
    _spController.close();
  }

  BehaviorSubject<Sp> _spController = BehaviorSubject.seeded(Sp());
  Sp get sp => _spController.value;
  Observable<Sp> get outSp => _spController.stream;

  Future<void> inContext(BuildContext context) async {
    if (_sp == null) {
      final sp = _sp.shouldUpdate(context);
      if (sp != null) _spController.add(sp);
    }
  }

  SpController();
}


mixin MixinSpManager implements SpManager{
  SpManager get spManager;
  Sp get sp => spManager.sp;

  Observable<Sp> get outSp => spManager.outSp;

  Future<void> inContext(BuildContext context) {
    return spManager.inContext(context);
  }
}
