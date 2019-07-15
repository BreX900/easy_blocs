import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class FittedText extends FittedBox {
  FittedText(String text, {
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
    BoxFit fit: BoxFit.scaleDown,
    Alignment alignment,
  }) : assert(text != null), super(
    child: Text(text,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    ),
    alignment: alignment??_getTextAlign(textAlign),
    fit: fit,
  );

  static Alignment _getTextAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.end:
        return Alignment.bottomRight;
      default:
        return Alignment.topLeft;
    }
  }
}

const light = FontWeight.w300, normal = FontWeight.w400, medium = FontWeight.w500;

class TextThemeSp extends TextTheme {
  TextThemeSp({
    @required Sp sp,
    bool adv: false,
    TextStyle display4,
    TextStyle display3,
    TextStyle display2,
    TextStyle display1,
    TextStyle headline,
    TextStyle title,
    TextStyle subhead,
    TextStyle body2,
    TextStyle body1,
    TextStyle caption,
    TextStyle button,
    TextStyle subtitle,
    TextStyle overline,
  }) : assert(sp != null), super(
    display4: _materialDesing2_0(sp, adv, display4, 96.0, light, -1.5, color: Colors.black, ),
    display3: _materialDesing2_0(sp, adv, display3, 60.0, light, -0.5, color: Colors.black, ),
    display2: _materialDesing2_0(sp, adv, display2, 48.0, normal, 0.0, color: Colors.black, ),
    display1: _materialDesing2_0(sp, adv, display1, 34.0, normal, 0.25, color: Colors.black, ),
    headline: _materialDesing2_0(sp, adv, headline, 24.0, normal, 0.0,),
    title: _materialDesing2_0(sp, adv, title, 20.0, medium, 0.15,),
    subhead: _materialDesing2_0(sp, adv, subhead, 16.0, normal, 0.15,),
    body2: _materialDesing2_0(sp, adv, body2, 16.0, normal, 0.5,),
    body1: _materialDesing2_0(sp, adv, body1, 14.0, normal, 0.25,),
    caption: _materialDesing2_0(sp, adv, button, 12.0, normal, 0.4,),
    button: _materialDesing2_0(
      sp, adv, button, 14.0, adv ? FontWeight.bold : medium, 0.75, color: Colors.white,),
    subtitle: _materialDesing2_0(sp, adv, subtitle, 14.0, medium, 0.1,),
    overline: _materialDesing2_0(
        sp, adv, overline, 10.0, normal, 1.5, decoration: TextDecoration.underline),
  );

  static TextStyle _materialDesing2_0(
      Sp sp, bool adv, TextStyle style, double fontSize, FontWeight fontWeight, double letterSpacing, {
        Color color, TextDecoration decoration,
  }) {
    fontSize = fontSize*2.75;
    letterSpacing = letterSpacing*1.25;
    final wordkSpacing = style?.wordSpacing == null ? null : sp.get(style.wordSpacing)*1.25;
    if (style == null)
      return TextStyle(
        fontSize: sp.get(fontSize),
        fontWeight: fontWeight,
        letterSpacing: sp.get(letterSpacing),
        wordSpacing: wordkSpacing,
        color: adv ? color : null,
        decoration: adv ? decoration : null,
      );
    return style.copyWith(
      fontSize: sp.get(style.fontSize??fontSize),
      fontWeight: style.fontWeight??fontWeight,
      letterSpacing: sp.get(style.letterSpacing??letterSpacing),
      wordSpacing: wordkSpacing,
      color: adv ? style.color??color : style.color,
      decoration: adv ? style.decoration??decoration : style.decoration,
    );
  }
}