import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheObservable.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef Translations Translator(Object value);


const String _defaultTranslation = 'en';

String translator(Translations translations) {
  return translations[RepositoryBloc.of().outLocale.value.languageCode]??
      translations[_defaultTranslation]??
      translations.values.first;
}


enum LoadingLanguage {
  SUCCESS, FAILED_OR_NOT_START,
}


class TranslatorController {
  static const _KEY = "UserTranslation";
  LoadingLanguage _loading = LoadingLanguage.FAILED_OR_NOT_START;

  TranslatorController() {
    _getStore();
  }

  void close() {
    _localeControl.close();
  }

  final CacheSubject<Locale> _localeControl = CacheSubject();
  CacheObservable<Locale> get outLocale => _localeControl.stream;

  Future<void> inContext(BuildContext context) async {
    if (_loading == LoadingLanguage.FAILED_OR_NOT_START)
      await inLocale(Localizations.localeOf(context));
  }

  Future<void> inLocale(Locale lc) async {
    assert(lc != null);

    if (lc != _localeControl.value) {
      _localeControl.add(lc);
      _updateStore(lc);
    }
  }

  Future<void> _getStore() async {
    final lc = (await SharedPreferences.getInstance()).getString(_KEY);
    if (lc != null) {
      _loading = LoadingLanguage.SUCCESS;
      await inLocale(Locale(lc));
    }
  }

  Future<void> _updateStore(Locale lc) async {
    await (await SharedPreferences.getInstance()).setString(_KEY, lc.languageCode);
  }
}


mixin MixinTranslatorController {
  TranslatorController get translatorController;
  CacheObservable<Locale> get outLocale => translatorController.outLocale;

  Future<void> inContext(BuildContext context) {
    return translatorController.inContext(context);
  }

  Future<void> inLocale(Locale lc) {
    return translatorController.inLocale(lc);
  }
}