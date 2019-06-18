import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/painting.dart';


class TranslationDrawer extends StatelessWidget {
  final translationBloc = TranslatorBloc.of();
  final List<Locale> locales;
  final String path;
  final double size;

  final Color backgroundColor;
  final EdgeInsets padding, flagPadding;

  TranslationDrawer({Key key, @required this.locales, @required this.path, this.size: 40,
    this.backgroundColor,
    this.padding: const EdgeInsets.symmetric(horizontal: 16.0),
    this.flagPadding: const EdgeInsets.all(8.0),
  }) :
        assert(locales != null), assert(path != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor??Theme.of(context).canvasColor,
      width: size+flagPadding.horizontal+padding.horizontal,
      child: SafeArea(
        right: false, left: false,
        child: ListView(
          padding: padding,
          children: locales.map((lc) {
            return FlagView(
              padding: flagPadding,
              locale: lc,
              path: path,
              size: size,
              child: InkWell(
                onTap: () {
                  translationBloc.inLocale(lc);
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}


class TranslationButton extends StatelessWidget {
  final translatorBloc = TranslatorBloc.of();
  final String path;
  final double size;

  TranslationButton({Key key, @required this.path, this.size: 40}) :
        assert(path != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder<Locale>(
      stream: translatorBloc.outLocale,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container();

        return FlagView(
          locale: snapshot.data,
          path: path,
          size: size,
          child: InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        );
      },
    );
  }
}


// TODO: COMPLETARE
class TranslationsInputDecoration extends InputDecoration {
  final Translations translationsHintText;

  const TranslationsInputDecoration({
    Widget icon,
    Translations labelText,
    TextStyle labelStyle,
    Translations helperText,
    TextStyle helperStyle,
    this.translationsHintText,
    TextStyle hintStyle,
    int hintMaxLines,
    Translations errorText,
    TextStyle errorStyle,
    int errorMaxLines,
    bool hasFloatingPlaceholder,
    bool isDense,
    EdgeInsetsGeometry contentPadding,
    bool isCollapsed,
    Widget prefixIcon,
    Widget prefix,
    Translations prefixText,
    TextStyle prefixStyle,
    Widget suffixIcon,
    Widget suffix,
    Translations suffixText,
    TextStyle suffixStyle,
    Translations counterText,
    Widget counter,
    TextStyle counterStyle,
    bool filled,
    Color fillColor,
    InputBorder errorBorder,
    InputBorder focusedBorder,
    InputBorder focusedErrorBorder,
    InputBorder disabledBorder,
    InputBorder enabledBorder,
    InputBorder border,
    bool enabled: true,
    String semanticCounterText,
    bool alignLabelWithHint,
  }) : super(
    icon: icon,
    labelStyle: labelStyle,
    helperStyle: helperStyle,
    hintStyle: hintStyle,
    hintMaxLines: hintMaxLines,
    errorStyle: errorStyle,
    errorMaxLines: errorMaxLines,
    hasFloatingPlaceholder: hasFloatingPlaceholder,
    isDense: isDense,
    contentPadding: contentPadding,
    prefixIcon: prefixIcon,
    prefix: prefix,
    prefixStyle: prefixStyle,
    suffixIcon: suffixIcon,
    suffixStyle: suffixStyle,
    counter: counter,
    counterStyle: counterStyle,
    filled: filled,
    fillColor: fillColor,
    errorBorder: errorBorder,
    focusedBorder: focusedBorder,
    focusedErrorBorder: focusedErrorBorder,
    disabledBorder: disabledBorder,
    enabledBorder: enabledBorder,
    border: border,
    enabled: enabled,
    semanticCounterText: semanticCounterText,
    alignLabelWithHint: alignLabelWithHint,
  );

  @override
  String get hintText => translationsHintText?.text;
}