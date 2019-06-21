import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RepositoryBloc with MixinTranslatorController, MixinSpController implements Bloc, SpController {
  @protected
  @override
  void dispose() {
    translatorController.close();
    spController.dispose();
  }

  final TranslatorController translatorController = TranslatorController();

  final SpController spController = SpController();


  SharedPreferences _sharedPreferences;
  SharedPreferences get sharedPreferences => _sharedPreferences;

  Future<void> inContext(BuildContext context) async {
    await translatorController.inContext(context);
    await spController.inContext(context);
  }

  RepositoryBloc.instance();
  factory RepositoryBloc.of() => $Provider.of<RepositoryBloc>();
  factory RepositoryBloc.init({@required SharedPreferences sharedPreferences}) {
   final bloc = $Provider.of<RepositoryBloc>();
   bloc._sharedPreferences = sharedPreferences;
   return bloc;
  }
  static void close() => $Provider.dispose<RepositoryBloc>();
}