// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Sp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sp _$SpFromJson(Map<String, dynamic> json) {
  return Sp(
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
    allowFontScaling: json['allowFontScaling'] as bool,
    mediaQueryData: const MediaQueryDataConverter()
        .fromJson(json['mediaQueryData'] as Map<String, dynamic>),
    pixelRatio: (json['pixelRatio'] as num)?.toDouble(),
    screenSize: json['screenSize'],
    statusBarHeight: (json['statusBarHeight'] as num)?.toDouble(),
    bottomBarHeight: (json['bottomBarHeight'] as num)?.toDouble(),
    textScaleFactor: (json['textScaleFactor'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SpToJson(Sp instance) => <String, dynamic>{
      'mediaQueryData':
          const MediaQueryDataConverter().toJson(instance.mediaQueryData),
      'width': instance.width,
      'height': instance.height,
      'allowFontScaling': instance.allowFontScaling,
      'screenSize': instance.screenSize,
      'pixelRatio': instance.pixelRatio,
      'statusBarHeight': instance.statusBarHeight,
      'bottomBarHeight': instance.bottomBarHeight,
      'textScaleFactor': instance.textScaleFactor,
    };
