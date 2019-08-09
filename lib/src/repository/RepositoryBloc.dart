import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/sp/SpController.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RepositoryBlocBase extends BlocBase with MixinTranslatorBone, MixinSpManager {
  @protected
  @override
  void dispose() {
    _translatorController.close();
    _spController.dispose();
    super.dispose();
  }

  final TranslatorSkeleton _translatorController = TranslatorSkeleton();
  TranslatorBone get translatorManager => _translatorController;

  final SpController _spController = SpController();
  SpManager get spManager => _spController;

  final SharedPreferences sharedPreferences;

  Future<void> inContext(BuildContext context) async {
    await _translatorController.inContext(context);
    await spManager.inContext(context);
  }

  final List<Locale> supportedLocales = [Locale('en'), Locale('it')];

  RepositoryBlocBase({@required this.sharedPreferences});

  factory RepositoryBlocBase.of() => BlocProvider.of<RepositoryBlocBase>();
}

