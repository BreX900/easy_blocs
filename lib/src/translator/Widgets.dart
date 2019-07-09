import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/painting.dart';


class TranslationDrawer extends StatelessWidget {
  final translationBloc = RepositoryBloc.of();
  final List<Locale> locales;
  final String assetFolder;
  final double size;

  final Color backgroundColor;
  final EdgeInsets padding, flagPadding;

  TranslationDrawer({Key key, @required this.locales, this.assetFolder: FlagView.ASSET_FOLDER, this.size: 40,
    this.backgroundColor,
    this.padding: const EdgeInsets.symmetric(horizontal: 16.0),
    this.flagPadding: const EdgeInsets.all(8.0),
  }) :
        assert(locales != null), assert(assetFolder != null), super(key: key);

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
              assetFolder: assetFolder,
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
  final translatorBloc = RepositoryBloc.of();
  final String assetFolder;
  final double size;

  TranslationButton({Key key, this.assetFolder: FlagView.ASSET_FOLDER, this.size: 40}) :
        assert(assetFolder != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder<Locale>(
      stream: translatorBloc.outLocale,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container();

        return FlagView(
          locale: snapshot.data,
          assetFolder: assetFolder,
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