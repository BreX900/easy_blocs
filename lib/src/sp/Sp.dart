import 'package:flutter/widgets.dart';


class Sp {
  factory Sp.context(BuildContext context, {
    double width: 1080,
    double height: 1920,
    bool allowFontScaling: false,
  }) {
    assert(context != null);

    final mediaQuery = MediaQuery.of(context);

    return Sp(
      width: width, height: height,
      allowFontScaling: allowFontScaling,
      mediaQueryData: mediaQuery,
      pixelRatio: mediaQuery.devicePixelRatio,
      screenSize: mediaQuery.size,
      statusBarHeight: mediaQuery.padding.top, bottomBarHeight: mediaQuery.padding.bottom,
      textScaleFactor: mediaQuery.textScaleFactor,
      scaleWidth: mediaQuery.size.width / width,
      scaleHeight: mediaQuery.size.height / height,
    );
  }

  bool shouldUpdate(BuildContext context) {
    return MediaQuery.of(context).size != screenSize;
  }

  const Sp({
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

  @override
  String toString() {
    return 'Sp(width: $width, height: $height, screenWidthDp: $screenWidthDp, screenHeightDp: $screenHeightDp, test: 18-${get(18)})';
  }
}