import 'package:easy_blocs/src/sp/Sp.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


const light = FontWeight.w300, normal = FontWeight.w400, medium = FontWeight.w500;

class TextThemeSp extends TextTheme {
  TextThemeSp({
    @required Sp sp,
    bool adv: false,
    String fontFamily,
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
    display4: _materialDesing2_0(sp, adv, display4, 96.0, light, -1.5, color: Colors.black, fontFamily: fontFamily),
    display3: _materialDesing2_0(sp, adv, display3, 60.0, light, -0.5, color: Colors.black, fontFamily: fontFamily),
    display2: _materialDesing2_0(sp, adv, display2, 48.0, normal, 0.0, color: Colors.black, fontFamily: fontFamily),
    display1: _materialDesing2_0(sp, adv, display1, 34.0, normal, 0.25, color: Colors.black, fontFamily: fontFamily),
    headline: _materialDesing2_0(sp, adv, headline, 24.0, normal, 0.0, fontFamily: fontFamily),
    title: _materialDesing2_0(sp, adv, title, 20.0, medium, 0.15, fontFamily: fontFamily),
    subhead: _materialDesing2_0(sp, adv, subhead, 16.0, normal, 0.15, fontFamily: fontFamily),
    body2: _materialDesing2_0(sp, adv, body2, 16.0, normal, 0.5, fontFamily:  fontFamily),
    body1: _materialDesing2_0(sp, adv, body1, 14.0, normal, 0.25, fontFamily: fontFamily),
    caption: _materialDesing2_0(sp, adv, button, 12.0, normal, 0.4, fontFamily: fontFamily),
    button: _materialDesing2_0(
      sp, adv, button, 14.0, adv ? FontWeight.bold : medium, 0.75, color: Colors.white, fontFamily: fontFamily),
    subtitle: _materialDesing2_0(sp, adv, subtitle, 14.0, medium, 0.1, fontFamily: fontFamily),
    overline: _materialDesing2_0(
        sp, adv, overline, 10.0, normal, 1.5, decoration: TextDecoration.underline, fontFamily: fontFamily),
  );

  static TextStyle _materialDesing2_0(
      Sp sp, bool adv, TextStyle style, double fontSize, FontWeight fontWeight, double letterSpacing, {
        Color color, TextDecoration decoration, String fontFamily,
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
        fontFamily: fontFamily,
      );
    return style.copyWith(
      fontSize: sp.get(style.fontSize??fontSize),
      fontWeight: style.fontWeight??fontWeight,
      letterSpacing: sp.get(style.letterSpacing??letterSpacing),
      wordSpacing: wordkSpacing,
      color: adv ? style.color??color : style.color,
      decoration: adv ? style.decoration??decoration : style.decoration,
      fontFamily: fontFamily,
    );
  }
}