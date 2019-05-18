import 'dart:ui';

import 'package:easy_blocs/src/rxdart_cache/CacheObservable.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheSubject.dart';
import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String _defaultTranslation = 'en';

String translator(Map<String, String> translations) {
  return translations[TranslatorBloc._languageCode]??translations[_defaultTranslation];
}


class TranslatorBloc implements Bloc {
  CacheSubject<Locale> _localeControl = CacheSubject();
  CacheObservable<Locale> get outLocale => _localeControl.stream;

  static const _KEY = "UserTranslation";

  static String _languageCode;
  String get languageCode => _languageCode;

  TranslatorBloc.instance();

  void init({@required Locale deviceLc})  {
    SharedPreferences.getInstance().then((prf) {
      final lc = prf.getString(_KEY);
      if (lc != null)
        deviceLc = Locale(lc);
      inLocale(deviceLc);
    });
  }

  bool get hasLocale => _localeControl.hasValue;

  @override
  dispose() {
    _localeControl.close();
  }

  inLocale(Locale lc) async {
    assert(lc != null);
    _languageCode = lc.languageCode;
    _localeControl.sink.add(lc);
  }
}