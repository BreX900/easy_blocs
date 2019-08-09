
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';


class TranslationsFieldDecoration {
  final InputDecoration decoration;
  final EdgeInsets padding;
  final int lines;

  const TranslationsFieldDecoration({Translations value,
    this.decoration: const InputDecoration(),
    this.padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    this.lines: 1,
  });

  TranslationsFieldDecoration copyWith({InputDecoration decoration, EdgeInsets padding, int lines}) {
    return TranslationsFieldDecoration(
      decoration: decoration??this.decoration,
      padding: padding??this.padding,
      lines: lines??this.lines,
    );
  }
}


abstract class TranslationsFieldBone extends FieldBone<Translations> {}


class TranslationsFieldSkeleton extends FieldSkeleton<Translations> implements TranslationsFieldBone {
  TranslationsFieldSkeleton({
    Translations value,
    List<FieldValidator<Translations>> validators,
  }): super(
    value: value,
    validators: validators??[TranslationsFieldValidator.validator],
  );
}


class TranslationsFieldShell extends StatefulWidget implements FocusShell {
  final TranslationsFieldBone bone;
  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final List<Locale> locales;

  final FieldErrorTranslator nosy;
  final TranslationsFieldDecoration decoration;

  const TranslationsFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,
    this.locales,
    this.nosy: byPassNoisy,
    this.decoration: const TranslationsFieldDecoration(),
  }) :
        assert(bone != null),
        super(key: key);

  @override
  TranslationsFieldShellState createState() => TranslationsFieldShellState();
}

class TranslationsFieldShellState extends State<TranslationsFieldShell>
    with FocusShellStateMixin, TickerProviderStateMixin {
  final repositoryBloc = RepositoryBlocBase.of();

  TabController _tabController;
  Map<String, TextEditingController> _textControllers;
  List<Locale> _locales;

  Translations _translations;

  @override
  void initState() {
    super.initState();
    _translations = widget.bone.value;
    _locales = widget.locales??repositoryBloc.supportedLocales;
    _tabController = TabController(
      length: _locales.length, vsync: this,
      initialIndex: _locales.indexWhere((lc) => lc.languageCode == repositoryBloc.locale.languageCode,
    ),
    );
    _textControllers = _locales.asMap().map((_, lc) {
      return MapEntry(lc.languageCode, TextEditingController());
    });
    _updateTranslations();
  }

  @override
  void didUpdateWidget(TranslationsFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_translations != widget.bone.value) {
      _translations = widget.bone.value;
      _updateTranslations();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updateTranslations() {
    if (_translations == null)
      return;

    _translations.toJson().forEach((lc, text) {
      final textController = _textControllers[lc];
      if (textController.text != text)
        _textControllers[lc].text = text;
    });
  }

  Translations _toTranslations() {
    return TranslationsMap.map(_textControllers.map((lc, textController) {
      return MapEntry(lc, textController.text);
    })..removeWhere((lc, text) => text == null || text.isEmpty));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<Translations>(
      onSaved: widget.bone.onSaved,
      validator: (value) {
        return widget.nosy(widget.bone.validator(value))?.text;
      },
      initialValue: _toTranslations(),
      builder: (state) {

        final labelStyle = theme.inputDecorationTheme.labelStyle??theme.textTheme.body1;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _locales.map((lc) {

                return FlagView(
                  locale: lc,
                  child: InkWell(),
                );
              }).toList(),
            ),
            DefaultTabBarBuilder(
              controller: _tabController,
              builder: (_, index, __) {
                final languageCode = _locales[index].languageCode;
                final textController = _textControllers[languageCode];

                return Padding(
                  padding: widget.decoration.padding,
                  child: TextField(
                    controller: textController,
                    onChanged: (text) {
                      // ignore: invalid_use_of_protected_member
                      state.setValue(_toTranslations());
                    },
                    decoration: widget.decoration.decoration.copyWith(
                      errorText: state.errorText,
                    ),
                    maxLines: widget.decoration.lines,
                    minLines: widget.decoration.lines,
                  ),
                );
              },
            ),
//            SizedBox(
//              height: (widget.decoration.lines*labelStyle.fontSize)
//                  + ((widget.decoration.lines-1)*(labelStyle.height??4.0))
//                  + (theme.inputDecorationTheme.contentPadding?.vertical??(20.0*2))
//                  + 10.0,
//              child: TabBarView(
//                controller: _tabController,
//                children: _locales.map((lc) {
//                  final languageCode = lc.languageCode;
//                  final textController = _textControllers[languageCode];
//
//                  return Padding(
//                    padding: widget.decoration.padding,
//                    child: TextField(
//                      controller: textController,
//                      onChanged: (text) {
//                        // ignore: invalid_use_of_protected_member
//                        state.setValue(_toTranslations());
//                      },
//                      decoration: widget.decoration.decoration,
//                      maxLines: widget.decoration.lines,
//                      minLines: widget.decoration.lines,
//                    ),
//                  );
//                }).toList(),
//              ),
//            ),
//            if (state.errorText != null)
//              Text("${state.errorText}",
//                style: theme.inputDecorationTheme.errorStyle,
//                maxLines: theme.inputDecorationTheme.errorMaxLines,
//              ),
          ],
        );
      },
    );
  }
}


class TranslationsFieldValidator {
  static const base = const [validator];

  static FieldError validator(Translations translations) {
    if (translations == null || translations.isUndefined)
      return TranslationsFieldError.undefined;
    return null;
  }
}


class TranslationsFieldError {
  static const undefined = FieldError.undefined;
}

//class TranslationsFieldShell<B extends TranslationsFieldBone>
//    extends FormField<Translations> implements FieldShell<B>, FocusShell {
//  @override
//  final B fieldBone;
//  @override
//  final MapFocusBone mapFocusBone;
//  @override
//  final FocusNode focusNode;
//
//  final List<Locale> locales;
//
//  final FieldShellDecorator<_TranslationsFieldShellState<B>> decorator;
//
//  TranslationsFieldShell({Key key,
//    this.locales,
//    this.fieldBone,
//    this.mapFocusBone, this.focusNode,
//    this.decorator,
//  }) : super(key: key,
//    initialValue: fieldBone.sheet,
//    validator: fieldBone.validator,
//    onSaved: fieldBone.onSaved,
//    builder: (FormFieldState<Translations> tmpState) {
//      final _TranslationsFieldShellState<B> state = tmpState;
//
//      return Column(
//        children: <Widget>[
//          TabBar(
//            controller: state._controller,
//            tabs: locales.map((lc) {
//              return FlagView(
//                locale: lc,
//              );
//            }).toList(),
//          ),
//          TabBarView(
//            controller: state._controller,
//            children: locales.map((lc) {
//              final languageCode = lc.languageCode;
//
//              return TextField(
//                onChanged: (str) {
//                  state._translations[languageCode] = str;
//                  state.didChange(TranslationsMap.map(state._translations));
//                },
//              );
//            }).toList(),
//          )
//        ],
//      );
//    },
//  );
//
//  @override
//  _TranslationsFieldShellState<B> createState() => _TranslationsFieldShellState<B>();
//}
//
//class _TranslationsFieldShellState<B extends TranslationsFieldBone>
//    extends FormFieldState<Translations> with TickerProviderStateMixin, FocusShellStateMixin {
//
//  final Map<String, String> _translations = Map();
//
//  final TabController _controller = TabController();
//}





//class TranslationsFieldSheet extends FieldSheet<Translations> {
//  final TextInputType keyboardType;
//
//  final bool obscureText;
//  final int maxLength;
//
//  final List<TextInputFormatter> inputFormatters;
//
//  const TranslationsFieldSheet({
//    Translations value,
//    this.keyboardType,
//    this.obscureText: false, this.maxLength,
//    this.inputFormatters,
//  }) : super(
//    value: value,
//  );
//
//  TranslationsFieldSheet copyWith({
//    Object value,
//    TextInputType keyboardType,
//    bool obscureText, int maxLength,
//    List<TextInputFormatter> inputFormatters,
//  }) {
//    return TranslationsFieldSheet(
//      value: value??this.value,
//      keyboardType: keyboardType??this.keyboardType,
//      obscureText: obscureText??this.obscureText,
//      maxLength: maxLength??this.maxLength,
//      inputFormatters: inputFormatters??this.inputFormatters,
//    );
//  }
//}