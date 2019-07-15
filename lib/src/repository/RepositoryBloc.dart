import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RepositoryBloc with MixinTranslatorManager, MixinSpManager implements Bloc, SpController {
  @protected
  @override
  void dispose() {
    _translatorController.close();
    _spController.dispose();
  }

  final TranslatorController _translatorController = TranslatorController();
  TranslatorManager get translatorManager => _translatorController;

  final SpController _spController = SpController();
  SpManager get spManager => _spController;

  SharedPreferences _sharedPreferences;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  Future<void> inContext(BuildContext context) async {
    await _translatorController.inContext(context);
    await spManager.inContext(context);
  }
  void init({@required SharedPreferences sharedPreferences}) {
    _sharedPreferences = sharedPreferences;
  }
  RepositoryBloc.instance();
  factory RepositoryBloc.of() => $Provider.of<RepositoryBloc>();
  static void close() => $Provider.dispose<RepositoryBloc>();
}