import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


class SpBloc implements Bloc {
  Sp _sp;

  @protected
  @override
  void dispose() {
    _spController.close();
  }

  CacheSubject<Sp> _spController = CacheSubject.seeded(Sp());
  CacheObservable<Sp> get outSp => _spController.stream;

  inContext(BuildContext context) {
    if (_sp == null || _sp.shouldUpdate(context)) {
      _sp = Sp.context(context);
      _spController.add(_sp);
    }
  }

  SpBloc.instance();
  factory SpBloc.of() => $Provider.of<SpBloc>();
  static void close() => $Provider.dispose<SpBloc>();
}



class Sp {
  factory Sp.context(BuildContext context, {
    double width: 1080,
    double height: 1920,
    bool allowFontScaling: false,
  }) {
    assert(context != null);

    final mediaQuery = MediaQuery.of(context);

    return Sp(
      width: width, height: height, allowFontScaling: allowFontScaling,
      mediaQueryData: mediaQuery, pixelRatio: mediaQuery.devicePixelRatio,
      screenSize: mediaQuery.size,
      statusBarHeight: mediaQuery.padding.top, bottomBarHeight: mediaQuery.padding.bottom,
      textScaleFactor: mediaQuery.textScaleFactor,
      scaleWidth: mediaQuery.size.width / width, scaleHeight: mediaQuery.size.height / height,
    );
  }

  bool shouldUpdate(BuildContext context) {
    return MediaQuery.of(context).size != screenSize;
  }

  Sp({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,

    this.mediaQueryData,
    this.pixelRatio: 3.0,
    this.screenSize: const Size(1080, 1920),
    this.statusBarHeight: 64.0,
    this.bottomBarHeight: 64.0,
    this.textScaleFactor: 1.0,
    this.scaleWidth: 1.0,
    this.scaleHeight: 1.0,
  });

  final MediaQueryData mediaQueryData;

  final double width;
  final double height;
  final bool allowFontScaling;

  final Size screenSize;
  final double pixelRatio;
  final double statusBarHeight;

  final double bottomBarHeight;

  final double textScaleFactor;

  final double scaleWidth;
  final double scaleHeight;


  //MediaQueryData get mediaQueryData => _mediaQueryData;

  //double get textScaleFactory => _textScaleFactor;
  //double get pixelRatio => _pixelRatio;

  /// dp
  double get screenWidthDp => screenSize.width;
  double get screenHeightDp => screenSize.height;
  /*Size get screenSize => _screenSize;

  /// px
  double get screenWidth => screenWidth * _pixelRatio;
  double get screenHeight => screenHeight * _pixelRatio;

  double get statusBarHeight => _statusBarHeight * _pixelRatio;
  double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  double get scaleWidth => _scaleWidth;
  double get scaleHeight => _scaleHeight;*/


  getWidth(double width) => width * scaleWidth;

  getHeight(double height) => height * scaleHeight;

  ///@param fontSize
  ///@param allowFontScaling false。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  get(double fontSize) => allowFontScaling ? getWidth(fontSize) : getWidth(fontSize) / textScaleFactor;
}