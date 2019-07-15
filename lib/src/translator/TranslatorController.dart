import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';


typedef Translations Translator(Object value);


const String _defaultTranslation = 'en';

String translator(Translations translations) {
  return translations[RepositoryBloc.of().locale.languageCode]
      ?? (translations[_defaultTranslation] ?? translations.values.first);
}


enum LoadingLanguage {
  SUCCESS, FAILED_OR_NOT_START,
}


abstract class TranslatorManager {
  Observable<Locale> get outLocale;
  Locale get locale;
  NumberFormat get currencyFormat;

  Future<void> inContext(BuildContext context);

  Future<void> inLocale(Locale lc);
}


/// In ThemeData add 'platform: TargetPlatform.android,'
class TranslatorController implements TranslatorManager{
  static const _KEY = "UserTranslation";
  LoadingLanguage _loading = LoadingLanguage.FAILED_OR_NOT_START;

  Locale get locale => _localeControl.value;

  TranslatorController({Locale locale: const Locale('en')}) : this._localeControl = BehaviorSubject.seeded(locale) {
    _getStore();
  }

  void close() {
    _localeControl.close();
  }

  final BehaviorSubject<Locale> _localeControl;
  Observable<Locale> get outLocale => _localeControl.stream;

  Future<void> inContext(BuildContext context) async {
    if (_loading == LoadingLanguage.FAILED_OR_NOT_START)
      await inLocale(Localizations.localeOf(context));
  }

  Future<void> inLocale(Locale lc) async {
    assert(lc != null);

    if (lc != locale) {
      _currencyFormat = NumberFormat.currency(locale: lc.toString(), symbol: '€');
      _localeControl.add(lc);
      await _updateStore();
    }
  }

  Future<void> _getStore() async {
    final lc = (await SharedPreferences.getInstance()).getString(_KEY);
    if (lc != null && lc.isNotEmpty) {
      _loading = LoadingLanguage.SUCCESS;
      await inLocale(Locale(lc));
    }
  }

  Future<void> _updateStore() async {
    await (await SharedPreferences.getInstance()).setString(_KEY, locale.languageCode);
  }

  NumberFormat _currencyFormat;
  NumberFormat get currencyFormat => _currencyFormat;
}


mixin MixinTranslatorManager implements TranslatorManager {
  TranslatorManager get translatorManager;
  Observable<Locale> get outLocale => translatorManager.outLocale;
  Locale get locale => translatorManager.locale;
  NumberFormat get currencyFormat => translatorManager.currencyFormat;

  Future<void> inContext(BuildContext context) {
    return translatorManager.inContext(context);
  }

  Future<void> inLocale(Locale lc) {
    return translatorManager.inLocale(lc);
  }
}