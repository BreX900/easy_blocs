// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case TranslatorBloc:
        {
          return BlocCache.getBlocInstance(
              "TranslatorBloc", () => TranslatorBloc.instance());
        }
      case SpBloc:
        {
          return BlocCache.getBlocInstance("SpBloc", () => SpBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case TranslatorBloc:
        {
          BlocCache.dispose("TranslatorBloc");
          break;
        }
      case SpBloc:
        {
          BlocCache.dispose("SpBloc");
          break;
        }
    }
  }
}
