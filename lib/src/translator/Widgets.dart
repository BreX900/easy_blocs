import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/painting.dart';


class TranslationDrawer extends StatelessWidget {
  final translationBloc = RepositoryBlocBase.of();
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
  final translatorBloc = RepositoryBlocBase.of();
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


class TranslationsInputDecoration extends InputDecoration {
  final Translations translationsLabelText;
  final Translations translationsHelperText;
  final Translations translationsHintText;
  final Translations translationsErrorText;
  final Translations translationsPrefixText;
  final Translations translationsSuffixText;
  final Translations translationsCounterText;

  const TranslationsInputDecoration({
    Widget icon,
    this.translationsLabelText, TextStyle labelStyle,
    this.translationsHelperText, TextStyle helperStyle,
    this.translationsHintText, TextStyle hintStyle, int hintMaxLines,
    this.translationsErrorText, TextStyle errorStyle, int errorMaxLines,
    bool hasFloatingPlaceholder: true, bool isDense, EdgeInsetsGeometry contentPadding, bool isCollapsed,
    Widget prefixIcon, Widget prefix, this.translationsPrefixText, TextStyle prefixStyle,
    Widget suffixIcon, Widget suffix, this.translationsSuffixText, TextStyle suffixStyle,
    this.translationsCounterText, Widget counter, TextStyle counterStyle,
    bool filled, Color fillColor, Color focusColor, Color hoverColor,
    InputBorder errorBorder, InputBorder focusedBorder, InputBorder focusedErrorBorder,
    InputBorder disabledBorder, InputBorder enabledBorder, InputBorder border,
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
    fillColor: fillColor, focusColor: focusColor, hoverColor: hoverColor,
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
  String get labelText => translationsLabelText?.text;
  @override
  String get helperText => translationsHelperText?.text;
  @override
  String get hintText => translationsHintText?.text;
  @override
  String get errorText => translationsErrorText?.text;
  @override
  String get prefixText => translationsPrefixText?.text;
  @override
  String get suffixText => translationsSuffixText?.text;
  @override
  String get counterText => translationsCounterText?.text;

  TranslationsInputDecoration copyWithTranslations({
    Widget icon,
    Translations translationsLabelText,
    TextStyle labelStyle,
    Translations translationsHelperText,
    TextStyle helperStyle,
    Translations translationsHintText,
    TextStyle hintStyle, int hintMaxLines,
    Translations translationsErrorText,
    TextStyle errorStyle, int errorMaxLines,
    bool hasFloatingPlaceholder, bool isDense, EdgeInsetsGeometry contentPadding,
    Widget prefixIcon, Widget prefix,
    Translations translationsPrefixText,
    TextStyle prefixStyle,
    Widget suffixIcon, Widget suffix,
    Translations translationsSuffixText,
    TextStyle suffixStyle,
    Widget counter,
    Translations translationsCounterText,
    TextStyle counterStyle,
    bool filled, Color fillColor,
    Color focusColor,
    Color hoverColor,
    InputBorder errorBorder, InputBorder focusedBorder,
    InputBorder focusedErrorBorder,
    InputBorder disabledBorder,
    InputBorder enabledBorder, InputBorder border,
    bool enabled,
    String semanticCounterText,
    bool alignLabelWithHint,
  }) {

    return TranslationsInputDecoration(
      icon: icon??this.icon,
      translationsLabelText: translationsLabelText??this.translationsLabelText,
      labelStyle: labelStyle??this.labelStyle,
      translationsHelperText: translationsHelperText??this.translationsHelperText,
      helperStyle: helperStyle??this.helperStyle,
      translationsHintText: translationsHintText??this.translationsHintText,
      hintStyle: hintStyle??this.hintStyle,
      hintMaxLines: hintMaxLines??this.hintMaxLines,
      translationsErrorText: translationsErrorText??this.translationsErrorText,
      errorStyle: errorStyle??this.errorStyle,
      errorMaxLines: errorMaxLines??this.errorMaxLines,
      hasFloatingPlaceholder: hasFloatingPlaceholder??this.hasFloatingPlaceholder,
      isDense: isDense??this.isDense,
      contentPadding: contentPadding??this.contentPadding,
      prefixIcon: prefixIcon??this.prefixIcon,
      prefix: prefix??this.prefix,
      translationsPrefixText: translationsPrefixText??this.translationsPrefixText,
      prefixStyle: prefixStyle??this.prefixStyle,
      suffixIcon: suffixIcon??this.suffixIcon,
      suffix: suffix??this.suffix,
      translationsSuffixText: translationsSuffixText??this.translationsSuffixText,
      suffixStyle: suffixStyle??this.suffixStyle,
      counter: counter??this.counter,
      translationsCounterText: translationsCounterText??this.translationsCounterText,
      counterStyle: counterStyle??this.counterStyle,
      filled: filled??this.filled,
      fillColor: fillColor??this.fillColor,
      focusColor: focusColor??this.focusColor,
      hoverColor: hoverColor??this.hoverColor,
      errorBorder: errorBorder??this.errorBorder,
      focusedBorder: focusedBorder??this.focusedBorder,
      focusedErrorBorder: focusedErrorBorder??this.focusedErrorBorder,
      disabledBorder: disabledBorder??this.disabledBorder,
      enabledBorder: enabledBorder??this.enabledBorder,
      border: border??this.border,
      enabled: enabled??this.enabled,
      semanticCounterText: semanticCounterText??this.semanticCounterText,
      alignLabelWithHint: alignLabelWithHint??this.alignLabelWithHint,
    );
  }
}