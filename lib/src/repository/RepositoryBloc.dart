import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/sp/SpController.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryBlocBase extends BlocBase with MixinTranslatorBone, MixinSpManager {
  @protected
  @override
  void dispose() {
    translatorSkeleton.close();
    spSkeleton.dispose();
    super.dispose();
  }

  final TranslatorSkeleton translatorSkeleton;
  TranslatorBone get translatorManager => translatorSkeleton;

  final SpSkeleton spSkeleton;
  SpBone get spManager => spSkeleton;

  final SharedPreferences sharedPreferences;

  final List<Locale> supportedLocales = [Locale('en'), Locale('it')];

  RepositoryBlocBase({
    @required this.sharedPreferences,
    @required this.translatorSkeleton,
    @required this.spSkeleton,
  });

  RepositoryBlocBase.fromData({@required RepositoryDataCreator data}) :
      assert(data != null),
      this.sharedPreferences = data.sharedPreferences,
        this.translatorSkeleton = data.translatorSkeleton,
        this.spSkeleton= data.spSkeleton;

  factory RepositoryBlocBase.of() => BlocProvider.of<RepositoryBlocBase>();
}
