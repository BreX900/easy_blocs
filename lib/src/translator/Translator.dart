import 'dart:async';
import 'dart:ui';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheObservable.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:dash/dash.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef Translations Translator(Object value);


const String _defaultTranslation = 'en';

String translator(Translations translations) {
  return translations[TranslatorBloc.of().outLocale.value.languageCode]??
      translations[_defaultTranslation]??
      translations.values.first;
}


enum LoadingLanguage {
  SUCCESS, FAILED_OR_NOT_START,
}


class TranslatorBloc implements Bloc {
  static const _KEY = "UserTranslation";
  LoadingLanguage _loading = LoadingLanguage.FAILED_OR_NOT_START;

  @protected
  @override
  dispose() {
    _localeControl.close();
  }

  final CacheSubject<Locale> _localeControl = CacheSubject();
  CacheObservable<Locale> get outLocale => _localeControl.stream;

  Future<void> inContext(BuildContext context) async {
    if (_loading == LoadingLanguage.FAILED_OR_NOT_START)
      await inLocale(Localizations.localeOf(context));
  }

  inLocale(Locale lc) async {
    assert(lc != null);

    if (lc != _localeControl.value) {
      _localeControl.add(lc);
      _updateStore(lc);
    }
  }

  getStore() async {
    final lc = (await SharedPreferences.getInstance()).getString(_KEY);
    if (lc != null) {
      _loading = LoadingLanguage.SUCCESS;
      await inLocale(Locale(lc));
    }
  }

  _updateStore(Locale lc) async {
    await (await SharedPreferences.getInstance()).setString(_KEY, lc.languageCode);
  }

  TranslatorBloc.instance() {
    getStore();
  }
  static TranslatorBloc of() => $Provider.of<TranslatorBloc>();
  static void close() => $Provider.dispose<TranslatorBloc>();
}


