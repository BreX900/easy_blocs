import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:rational/rational.dart';


class PriceView extends Text {
  PriceView(Rational price, {
    Key key,
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
  }) : super.rich(PriceSpan(price),
    key: key,
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
  );
}

class PriceSpan extends TextSpan {

  PriceSpan(Rational price, {
    TextStyle style,
    List<TextSpan> children,
    GestureRecognizer recognizer,
    String semanticsLabel,
  }) : super(
    style: style,
    text: '${RepositoryBlocBase.of().currencyFormat.format(price.toDouble())}',
    children: children,
    recognizer: recognizer,
    semanticsLabel: semanticsLabel,
  );
}