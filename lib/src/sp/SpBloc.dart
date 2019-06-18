import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


class SpBloc implements Bloc {
  Sp _sp;

  @protected
  @override
  void dispose() {
    _spController.close();
  }

  CacheSubject<Sp> _spController = CacheSubject.seeded(Sp());
  CacheObservable<Sp> get outSp => _spController.stream;

  inContext(BuildContext context) {
    if (_sp == null || _sp.shouldUpdate(context)) {
      _sp = Sp.context(context);
      _spController.add(_sp);
    }
  }

  SpBloc.instance();
  factory SpBloc.of() => $Provider.of<SpBloc>();
  static void close() => $Provider.dispose<SpBloc>();
}



