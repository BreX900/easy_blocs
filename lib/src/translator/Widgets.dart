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