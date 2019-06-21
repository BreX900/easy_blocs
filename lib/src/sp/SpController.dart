import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class SpController {
  Sp get _sp => _spController.value;

  void dispose() {
    _spController.close();
  }

  CacheSubject<Sp> _spController = CacheSubject.seeded(Sp());
  CacheObservable<Sp> get outSp => _spController.stream;

  Future<void> inContext(BuildContext context) async {
    if (_sp == null || _sp.shouldUpdate(context)) {
      _spController.add(Sp.context(context));
    }
  }

  SpController() {
    _spController.listen(print);
  }
}


mixin MixinSpController {
  SpController get spController;

  CacheObservable<Sp> get outSp => spController.outSp;

  Future<void> inContext(BuildContext context) {
    return spController.inContext(context);
  }
}
