import 'dart:ui';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheObservable.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:dash/dash.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef Translations Translator<V>(V value);


const String _defaultTranslation = 'en';

String translator(Map<String, String> translations) {
  return translations[TranslatorBloc.of().outLocale.value]??translations[_defaultTranslation];
}


class TranslatorBloc implements Bloc {
  TranslatorBloc.instance();

  @protected
  @override
  dispose() {
    _localeControl.close();
  }

  final CacheSubject<Locale> _localeControl = CacheSubject();
  CacheObservable<Locale> get outLocale => _localeControl.stream;

  static const _KEY = "UserTranslation";

  void init({@required Locale deviceLc}) async {
    final lc = (await SharedPreferences.getInstance()).getString(_KEY);
    if (lc != null)
      deviceLc = Locale(lc);
    _localeControl.sink.add(deviceLc);
  }

  inLocale(Locale lc) async {
    assert(lc != null);
    _localeControl.sink.add(lc);
    await (await SharedPreferences.getInstance()).setString(_KEY, lc.languageCode);
  }

  static TranslatorBloc of() => $Provider.of<TranslatorBloc>();
  static void close() => $Provider.dispose<TranslatorBloc>();
}


