import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

typedef Translations Translator(Object value);

const String _defaultTranslation = 'en';

String translator(Translations translations) {
  return translations[RepositoryBlocBase.of().locale.languageCode] ??
      (translations[_defaultTranslation] ??
          () {
            final values = translations.values;
            if (values.length == 0) return "";
            return values.first;
          }());
}

enum LoadingLanguage {
  SUCCESS,
  FAILED_OR_NOT_START,
}

abstract class TranslatorBone implements Bone {
  //Observable<Locale> get outLocale;
  Locale get locale;
  NumberFormat get currencyFormat;

  void inLocale(Locale lc);
}

/// In ThemeData add 'platform: TargetPlatform.android,'
class TranslatorSkeleton extends Skeleton implements TranslatorBone {
  static const _KEY = "UserTranslation";
  LoadingLanguage _loading = LoadingLanguage.FAILED_OR_NOT_START;

  Locale get locale => _localeControl.value;

  TranslatorSkeleton({Locale locale: const Locale('en')})
      : this._localeControl = BehaviorSubject.seeded(locale) {
    _currencyFormat = NumberFormat.currency(locale: locale.toString(), symbol: '€');
    _getStore();
  }

  void close() {
    _localeControl.close();
  }

  final BehaviorSubject<Locale> _localeControl;
  Observable<Locale> get outLocale => _localeControl.stream;

  void inLocale(Locale lc) {
    assert(lc != null);

    if (lc != locale) {
      _localeControl.add(lc);
      _currencyFormat = NumberFormat.currency(locale: locale.toString(), symbol: '€');
      _updateStore();
    }
  }

  Future<void> _getStore() async {
    final lc = (await SharedPreferences.getInstance()).getString(_KEY);
    if (lc != null && lc.isNotEmpty) {
      _loading = LoadingLanguage.SUCCESS;
      inLocale(Locale(lc));
    }
  }

  Future<void> _updateStore() async {
    await (await SharedPreferences.getInstance()).setString(_KEY, locale.languageCode);
  }

  NumberFormat _currencyFormat;
  NumberFormat get currencyFormat => _currencyFormat;

  void inDeviceLocale(Locale lc) {
    if (_loading == LoadingLanguage.FAILED_OR_NOT_START) inLocale(lc);
  }
}

mixin MixinTranslatorBone implements TranslatorBone {
  TranslatorBone get translatorManager;
  //Observable<Locale> get outLocale => translatorManager.outLocale;
  Locale get locale => translatorManager.locale;
  NumberFormat get currencyFormat => translatorManager.currencyFormat;

  void inLocale(Locale lc) => translatorManager.inLocale(lc);
}

//mixin TranslatorObserver<W extends StatefulWidget> on WidgetsBindingStateListener<W> {
//  @override
//  void didChangeMetrics() {
//    super.didChangeMetrics();
//    print(widgetsBinding.window.locale);
//  }
//}
