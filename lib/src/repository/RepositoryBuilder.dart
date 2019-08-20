import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


typedef Widget _Builder(BuildContext context, RepositoryData data);

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


  ObservableSubscriber<Data2<Locale, Sp>> _dataSubscriber;

  RepositoryData _data;

  @override
  void initState() {
    super.initState();
    _dataSubscriber = ObservableSubscriber(_dataListener);
  }

  @override
  void dispose() {
    _dataSubscriber.unsubscribe();
    super.dispose();
  }

  Future<void> _init(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    
    final repositoryBloc = widget.creator(sharedPreferences);
    assert(repositoryBloc != null);
    BlocProvider.init<RepositoryBlocBase>(repositoryBloc);

    _data = RepositoryData(
      screen: await widget.worker(context, sharedPreferences),
      locale: repositoryBloc.locale,
      sp: repositoryBloc.sp,
    );

    _dataSubscriber.subscribe(Data2.combineLatest(repositoryBloc.outLocale, repositoryBloc.outSp));
  }

  void _dataListener(ObservableState<Data2<Locale, Sp>> update) {
    setState(() => _data = _data.copyWith(
      locale: update.data.data1,
      sp: update.data.data2,
    ));
  }

  @override
  Widget build(BuildContext context) {

    if (_data == null) {
      _init(context);
      return widget.splashWidget??Container(
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    print("BUILD ${_data.sp}");
    return widget.builder(context, _data);
  }
}


class RepositoryData {
  final RepositoryBlocBase repositoryBloc;
  final Locale locale;
  final Sp sp;
  final SharedPreferences sharedPreferences;
  final String screen;

  RepositoryData({this.repositoryBloc, this.locale, this.sp, this.sharedPreferences, this.screen});

  RepositoryData copyWith({SharedPreferences sharedPreferences, Locale locale, Sp sp, String screen}) {
    return RepositoryData(
      repositoryBloc: sharedPreferences??this.repositoryBloc,
      locale: locale??this.locale,
      sp: sp??this.sp,
      screen: screen??this.screen,
    );
  }
}