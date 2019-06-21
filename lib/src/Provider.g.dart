// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case RepositoryBloc:
        {
          return BlocCache.getBlocInstance(
              "RepositoryBloc", () => RepositoryBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case RepositoryBloc:
        {
          BlocCache.dispose("RepositoryBloc");
          break;
        }
    }
  }
}
