import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Sp.g.dart';

@JsonSerializable()
@MediaQueryDataConverter()
class Sp {
  factory Sp.fromMediaQueryData(
    MediaQueryData mediaQueryData, {
    double width: 1080,
    double height: 1920,
    bool allowFontScaling: false,
  }) {
    assert(mediaQueryData != null);
    if (mediaQueryData.size.isEmpty) return null;

    //print("W: $width, H: $height");

    return Sp(
      width: width,
      height: height,
      allowFontScaling: allowFontScaling,
      mediaQueryData: mediaQueryData,
      pixelRatio: mediaQueryData.devicePixelRatio,
      screenSize: mediaQueryData.size,
      statusBarHeight: mediaQueryData.padding.top,
      bottomBarHeight: mediaQueryData.padding.bottom,
      textScaleFactor: mediaQueryData.textScaleFactor,
    );
  }

  factory Sp.context(
    BuildContext context, {
    double width: 1080,
    double height: 1920,
    bool allowFontScaling: false,
  }) {
    assert(context != null);

    final mediaQueryData = MediaQuery.of(context);

    return Sp.fromMediaQueryData(
      mediaQueryData,
      width: width,
      height: height,
      allowFontScaling: allowFontScaling,
    );
  }

//  Sp shouldUpdate(BuildContext context) {
//    final sp = Sp.context(context);
//
//    return sp.pixelRatio == pixelRatio &&
//            sp.screenSize == screenSize &&
//            sp.statusBarHeight == statusBarHeight &&
//            sp.bottomBarHeight == bottomBarHeight &&
//            sp.textScaleFactor == textScaleFactor
//        ? null
//        : sp;
//  }

  Sp({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
    this.mediaQueryData,
    this.pixelRatio: 3.0,
    this.screenSize: const Size(360, 640), // Samsung A2 2017
    this.statusBarHeight: 64.0,
    this.bottomBarHeight: 64.0,
    this.textScaleFactor: 1.0,
  })  : this.scaleWidth = screenSize.width / width,
        this.scaleHeight = screenSize.height / height;

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
  get(double fontSize) =>
      allowFontScaling ? getHeight(fontSize) : getHeight(fontSize) / textScaleFactor;

  @override
  String toString() {
    return 'Sp(width: $width, height: $height, screenSize: $screenSize, screenWidthDp: $screenWidthDp, screenHeightDp: $screenHeightDp, test: 18-${get(18)})';
  }

  static Sp fromJson(Map json) => _$SpFromJson(json);
  static Map toJson(Sp sp) => _$SpToJson(sp);

  bool sameTo(Sp other) =>
      other.pixelRatio == pixelRatio &&
      other.screenSize == screenSize &&
      other.statusBarHeight == statusBarHeight &&
      other.bottomBarHeight == bottomBarHeight &&
      other.textScaleFactor == textScaleFactor;
}

class MediaQueryDataConverter implements JsonConverter<MediaQueryData, Map<String, dynamic>> {
  const MediaQueryDataConverter();

  static const String _size = 'size',
      _devicePixelRatio = 'devicePixelRatio',
      _textScaleFactor = 'textScaleFactor',
      _platformBrightness = 'platformBrightness',
      _padding = 'padding',
      _viewInsets = 'viewInsets',
      _viewPadding = 'viewPadding',
      _alwaysUse24HourFormat = 'alwaysUse24HourFormat',
      _accessibleNavigation = 'accessibleNavigation',
      _invertColors = 'invertColors',
      _disableAnimations = 'disableAnimations',
      _boldText = 'boldText';
  @override
  MediaQueryData fromJson(Map<String, dynamic> json) {
    return MediaQueryData(
      size: _sizeFromJson(json[_size]),
      devicePixelRatio: json[_devicePixelRatio],
      textScaleFactor: json[_textScaleFactor],
      platformBrightness: _brightnessFromJson(json[_platformBrightness]),
      padding: _edgeInsetsFromJson(json[_padding]),
      viewInsets: _edgeInsetsFromJson(json[_viewInsets]),
      viewPadding: _edgeInsetsFromJson(json[_viewPadding]),
      alwaysUse24HourFormat: json[_alwaysUse24HourFormat],
      accessibleNavigation: json[_accessibleNavigation],
      invertColors: json[_invertColors],
      disableAnimations: json[_disableAnimations],
      boldText: json[_boldText],
    );
  }

  @override
  Map<String, dynamic> toJson(MediaQueryData object) {
    return {
      _size: _sizeToJson(object.size),
      _devicePixelRatio: object.devicePixelRatio,
      _textScaleFactor: object.textScaleFactor,
      _platformBrightness: _brightnessToJson(object.platformBrightness),
      _padding: _edgeInsetsToJson(object.padding),
      _viewInsets: _edgeInsetsToJson(object.viewInsets),
      _viewPadding: _edgeInsetsToJson(object.viewPadding),
      _alwaysUse24HourFormat: object.alwaysUse24HourFormat,
      _accessibleNavigation: object.accessibleNavigation,
      _invertColors: object.invertColors,
      _disableAnimations: object.disableAnimations,
      _boldText: object.boldText,
    };
  }

  static const String _width = "width", _height = "height";
  static Size _sizeFromJson(Map<String, double> json) {
    return Size(json[_width], json[_height]);
  }

  static Map<String, double> _sizeToJson(Size data) {
    return {
      _width: data.width,
      _height: data.height,
    };
  }

  static const String _dark = 'dark', _light = 'light';
  static Brightness _brightnessFromJson(String json) {
    switch (json) {
      case _dark:
        return Brightness.dark;
      case _light:
        return Brightness.light;
      default:
        return null;
    }
  }

  static String _brightnessToJson(Brightness data) {
    switch (data) {
      case Brightness.dark:
        return "dark";
      case Brightness.light:
        return "light";
      default:
        return null;
    }
  }

  static const String _left = 'left', _top = 'top', _right = 'right', _bottom = 'bottom';
  static EdgeInsets _edgeInsetsFromJson(Map json) {
    return EdgeInsets.fromLTRB(json[_left], json[_top], json[_right], json[_bottom]);
  }

  static Map _edgeInsetsToJson(EdgeInsets data) {
    return {
      _left: data.left,
      _top: data.top,
      _right: data.right,
      _bottom: data.bottom,
    };
  }
}
