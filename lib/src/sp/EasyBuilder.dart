import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/sp/SpBloc.dart';
import 'package:flutter/widgets.dart';


typedef Widget _EasyBuilder(Locale locale, Sp sp);


class EasyBuilder extends StatefulWidget {
  final _EasyBuilder builder;

  const EasyBuilder({Key key,
    @required this.builder,
  }) : assert(builder != null), super(key: key);

  @override
  _EasyBuilderState createState() => _EasyBuilderState();
}

class _EasyBuilderState extends State<EasyBuilder> {
  final _translatorBloc = TranslatorBloc.of();
  final _spBloc = SpBloc.of();

  StreamSubscription<Locale> _localeSub;
  StreamSubscription<Sp> _spSub;

  Locale _locale;
  Sp _sp = Sp();

  @override
  void initState() {
    super.initState();
    _locale = _translatorBloc.outLocale.value;
    _sp = _spBloc.outSp.value;
    _localeSub = _translatorBloc.outLocale.listen((locale) {
      setState(() {
        _locale = locale;
      });
    });
    _spSub = _spBloc.outSp.listen((sp) {
      setState(() {
        _sp = sp;
      });
    });
  }

  @override
  void dispose() {
    _localeSub.cancel();
    _spSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_locale, _sp);
  }
}
