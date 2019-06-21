import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Widget _RepositoryBuilder<T>(T data);


typedef  Future<T> _BackgroundTask<T>(BuildContext context, SharedPreferences sharedPreferences);


class RepositoryBuilder<T> extends StatelessWidget {
  final _RepositoryBuilder builder;

  final _BackgroundTask<T> backgroundTask;

  final Widget splashWidget;

  RepositoryBuilder({Key key,
    @required this.builder,
    @required this.backgroundTask,
    this.splashWidget,
  }) : assert(builder != null), assert(backgroundTask != null), super(key: key);

  Future<RepositoryData<T>> _future(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    RepositoryBloc.init(sharedPreferences: sharedPreferences);
    final data = await backgroundTask(context, sharedPreferences);
    return RepositoryData<T>(sharedPreferences: sharedPreferences, data: data);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<RepositoryData<T>>(
      initialData: null,
      future: _future(context),
      builder: (_, snapshot) {

        if (!snapshot.hasData) {
          return splashWidget??Container(
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        final _bloc = RepositoryBloc.of();

        return StreamBuilder<RepositoryData<T>>(
          initialData: snapshot.data.copyWith(sp: const Sp()),
          stream: Observable.combineLatest2(_bloc.outLocale, _bloc.outSp, (locale, sp) {
            return snapshot.data.copyWith(locale: locale, sp: sp);
          }),
          builder: (context, snap) {
            return builder(snap.data);
          },
        );
      }
    );
  }
}


class RepositoryData<T> {
  final SharedPreferences sharedPreferences;
  final Locale locale;
  final Sp sp;
  final T data;

  RepositoryData({this.sharedPreferences, this.locale, this.sp, this.data});

  RepositoryData<T> copyWith({SharedPreferences sharedPreferences, Locale locale, Sp sp, T data}) {
    return RepositoryData<T>(
      sharedPreferences: sharedPreferences??this.sharedPreferences,
      locale: locale??this.locale,
      sp: sp??this.sp,
      data: data??this.data,
    );
  }
}