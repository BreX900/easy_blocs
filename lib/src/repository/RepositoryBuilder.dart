import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef Widget _Builder(String screen);

typedef  Future<String> _Worker(BuildContext context, SharedPreferences sharedPreferences);

typedef RepositoryBlocBase _Creator(SharedPreferences sharedPreferences);


class RepositoryBuilder<T> extends StatefulWidget {
  final _Builder builder;

  final _Creator creator;

  final _Worker worker;

  final Widget splashWidget;

  RepositoryBuilder({Key key,
    this.creator: _repositoryInit,
    this.worker,
    @required this.builder,
    this.splashWidget,
  }) : assert(builder != null), assert(creator != null), super(key: key);

  static RepositoryBlocBase _repositoryInit(SharedPreferences sharedPreferences) {
    return RepositoryBlocBase(sharedPreferences: sharedPreferences);
  }

  @override
  _RepositoryBuilderState<T> createState() => _RepositoryBuilderState<T>();
}

class _RepositoryBuilderState<T> extends State<RepositoryBuilder<T>> {

  String _screen;

  Future<void> _init(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    
    final repositoryBloc = widget.creator(sharedPreferences);
    assert(repositoryBloc != null);
    BlocProvider.init<RepositoryBlocBase>(repositoryBloc);

    final screen = await widget.worker(context, sharedPreferences);
    setState(() => _screen = screen);
  }

  @override
  Widget build(BuildContext context) {

    if (_screen == null) {
      _init(context);
      return widget.splashWidget??Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    return widget.builder(_screen);
//    return StreamBuilder<RepositoryData<T>>(
//      initialData: _sheet,
//      stream: Observable.combineLatest2(
//          _sheet.repositoryBloc.outLocale, _sheet.repositoryBloc.outSp, (locale, sp) {
//        return _sheet.copyWith(locale: locale, sp: sp);
//      }),
//      builder: (context, snap) {
//        return;
//      },
//    );
  }
}


//class RepositoryData<T> {
//  final RepositoryBlocBase repositoryBloc;
//  final Locale locale;
//  final Sp sp;
//  final T data;
//
//  RepositoryData({this.repositoryBloc, this.locale, this.sp, this.data});
//
//  RepositoryData<T> copyWith({SharedPreferences sharedPreferences, Locale locale, Sp sp, T data}) {
//    return RepositoryData<T>(
//      repositoryBloc: sharedPreferences??this.repositoryBloc,
//      locale: locale??this.locale,
//      sp: sp??this.sp,
//      data: data??this.data,
//    );
//  }
//}