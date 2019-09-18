import 'dart:async';

import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:easy_blocs/src/rxdart/Data.dart';
import 'package:easy_blocs/src/rxdart/ObservableBuilder.dart';
import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:easy_blocs/src/sp/SpController.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' show Window;

typedef Widget _Builder(BuildContext context, RepositoryData data);

typedef Future<String> _Worker(BuildContext context, SharedPreferences sharedPreferences);

typedef R _Creator<R extends RepositoryBlocBase>(RepositoryDataCreator data);

class RepositoryBuilder<R extends RepositoryBlocBase> extends StatefulWidget {
  final _Builder builder;

  final _Creator<R> creator;

  final _Worker worker;

  final Widget splashWidget;

  RepositoryBuilder({
    Key key,
    @required this.creator,

    /// Passagli il RepositoryBlocBase senza ereditare.
    @required this.worker,
    @required this.builder,
    this.splashWidget,
  })  : assert(builder != null),
        assert(creator != null),
        super(key: key);

  @override
  _RepositoryBuilderState<R> createState() => _RepositoryBuilderState<R>();
}

class _RepositoryBuilderState<R extends RepositoryBlocBase> extends State<RepositoryBuilder<R>>
    with WidgetsBindingObserver, WidgetsBindingStateListener {
  ObservableSubscriber<Data2<Locale, Sp>> _dataSubscriber;

  bool isPerform;
  RepositoryData _data;

  TranslatorSkeleton _translatorSkeleton = TranslatorSkeleton();
  SpSkeleton _spSkeleton = SpSkeleton();

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

  void _init(BuildContext context) async {
    if (isPerform != null) return;
    isPerform = true;

    final sharedPreferencesWait = SharedPreferences.getInstance();
    Future(() {
      _updateWindow(widgetsBinding.window);

      sharedPreferencesWait.then((sharedPreferences) async {
        final _repositoryBloc = widget.creator(RepositoryDataCreator(
          sharedPreferences: sharedPreferences,
          spSkeleton: _spSkeleton,
          translatorSkeleton: _translatorSkeleton,
        ));
        assert(_repositoryBloc != null);
        BlocProvider.init<RepositoryBlocBase>(_repositoryBloc);
        BlocProvider.init<R>(_repositoryBloc);

        final screen = await widget.worker(context, sharedPreferences);
        await _waitChangeMetrics.future;
        _data = RepositoryData(
          screen: screen,
          locale: _translatorSkeleton.locale,
          sp: _spSkeleton.sp,
        );

        _dataSubscriber
            .subscribe(Data2.combineLatest(_translatorSkeleton.outLocale, _spSkeleton.outSp));
        isPerform = false;
      });
    });
  }

  Completer<void> _waitChangeMetrics = Completer();
  Future<void> didChangeMetrics() async {
    _updateWindow(widgetsBinding.window);
  }

  void _updateWindow(Window window) {
    final data = MediaQueryData.fromWindow(window);
    if (data.size.isEmpty) return;
    if (!_waitChangeMetrics.isCompleted) _waitChangeMetrics.complete();

    _translatorSkeleton.inDeviceLocale(window.locale);
    _spSkeleton.inMediaQueryData(data);
  }

  void _dataListener(ObservableState<Data2<Locale, Sp>> update) {
    setState(() => _data = _data.copyWith(locale: update.data.data1, sp: update.data.data2));
  }

  @override
  Widget build(BuildContext context) {
    if (isPerform != false) {
      _init(context);
      return widget.splashWidget ??
          Container(
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
    }

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

  RepositoryData copyWith(
      {SharedPreferences sharedPreferences, Locale locale, Sp sp, String screen}) {
    return RepositoryData(
      repositoryBloc: sharedPreferences ?? this.repositoryBloc,
      locale: locale ?? this.locale,
      sp: sp ?? this.sp,
      screen: screen ?? this.screen,
    );
  }
  @override
  String toString() => "$runtimeType(locale: $locale, sp: $sp"
      ", sharedPreferences: $sharedPreferences, screen: $screen)";
}

class RepositoryDataCreator {
  final SharedPreferences sharedPreferences;
  final SpSkeleton spSkeleton;
  final TranslatorSkeleton translatorSkeleton;

  RepositoryDataCreator({
    this.sharedPreferences,
    this.spSkeleton,
    this.translatorSkeleton,
  });
}

mixin WidgetsBindingStateListener<W extends StatefulWidget> on State<W>
    implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  WidgetsBinding get widgetsBinding => WidgetsBinding.instance;
}
