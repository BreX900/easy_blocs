
import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class TranslationsFieldSheet {
  final bool isEnable;

  const TranslationsFieldSheet({
    this.isEnable: true,
  }): assert(isEnable != null);

  TranslationsFieldSheet copyWith({FieldError error, bool isEnable,}) {
    return TranslationsFieldSheet(
      isEnable: isEnable??this.isEnable,
    );
  }
}


class TranslationsDecoration {
  final InputDecoration decoration;
  final int maxLines, minLines;

  final EdgeInsets padding;

  const TranslationsDecoration({
    this.decoration: const InputDecoration(),
    this.maxLines: 1, this.minLines: 1,

    this.padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
  });

  TranslationsDecoration copyWith({InputDecoration decoration, bool isEnable, int maxLines, int minLines}) {
    return TranslationsDecoration(
      decoration: decoration ?? this.decoration,
      maxLines: maxLines??this.maxLines,
      minLines : minLines ?? this.minLines,
    );
  }
}


abstract class TranslationsFieldBone extends FieldBone<Translations> {
  Stream<TranslationsFieldSheet> get outSheet;
  Stream<Data2<TranslationsFieldSheet, FieldError>> get outSheetAndError;
}


class TranslationsFieldSkeleton extends FieldSkeleton<Translations> implements TranslationsFieldBone {
  TranslationsFieldSkeleton({
    Translations seed,
    List<FieldValidator<Translations>> validators,
  }): super(
    seed: seed,
    validators: validators??TranslationsFieldValidator.base,
  );

  @override
  void dispose() {
    _sheetController.close();
    super.dispose();
  }

  BehaviorSubject<TranslationsFieldSheet> _sheetController = BehaviorSubject.seeded(const TranslationsFieldSheet());
  Stream<TranslationsFieldSheet> get outSheet => _sheetController;
  TranslationsFieldSheet get sheet => _sheetController.value;
  void inSheet(TranslationsFieldSheet sheet) => _sheetController.add(sheet);

  Stream<Data2<TranslationsFieldSheet, FieldError>> _outSheetAndError;
  Stream<Data2<TranslationsFieldSheet, FieldError>> get outSheetAndError {
    if (_outSheetAndError == null)
      _outSheetAndError = Data2.combineLatest(outSheet, outError);
    return _outSheetAndError;
  }

  @override
  void inFieldState(FieldState state) => inSheet(sheet.copyWith(isEnable: state == FieldState.active));
}


class TranslationsFieldShell extends StatefulWidget implements FieldShell, FocusShell {
  final TranslationsFieldBone bone;
  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final List<Locale> locales;

  final FieldErrorTranslator nosy;

  final TranslationsDecoration decoration;

  const TranslationsFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,
    this.locales,
    this.nosy: byPassNoisy,
    this.decoration: const TranslationsDecoration(),
  }) :
        assert(bone != null),
        super(key: key);

  @override
  TranslationsFieldShellState createState() => TranslationsFieldShellState();
}

class TranslationsFieldShellState extends State<TranslationsFieldShell>
    with FieldStateMixin, FocusShellStateMixin, TickerProviderStateMixin {
  final repositoryBloc = RepositoryBlocBase.of();

  TabController _tabController;
  Map<String, TextEditingController> _textControllers;
  List<Locale> _locales;

  ObservableSubscriber<Translations> _valueSubscriber;

  @override
  void initState() {
    _locales = widget.locales??repositoryBloc.supportedLocales;
    _tabController = TabController(
      length: _locales.length, vsync: this,
      initialIndex: _locales.indexWhere((lc) => lc.languageCode == repositoryBloc.locale.languageCode,
      ),
    );
    _textControllers = _locales.asMap().map((_, lc) {
      return MapEntry(lc.languageCode, TextEditingController());
    });
    super.initState();
    _valueSubscriber = ObservableSubscriber(_valueListener)..subscribe(widget.bone.outValue);
  }

  @override
  void didUpdateWidget(TranslationsFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _valueSubscriber..unsubscribe()..subscribe(widget.bone.outValue);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textControllers.values.forEach((controller) => controller.dispose());
    _valueSubscriber.unsubscribe();
    super.dispose();
  }

  void _valueListener(ObservableState<Translations> update) {
    (update.data??const TranslationsConst()).toJson().forEach((lc, text) {
      final textController = _textControllers[lc];
      if (textController == null || textController.text == text)
        return;
      textController.text = text;
    });
  }

  Translations _toTranslations() {
    return TranslationsMap.map(_textControllers.map((lc, textController) {
      return MapEntry(lc, textController.text);
    })..removeWhere((lc, text) => text == null || text.isEmpty));
  }

  @override
  Widget build(BuildContext context) {

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

            return ObservableBuilder<Data2<TranslationsFieldSheet, FieldError>>((_, data, state) {

              return TextField(
                controller: textController,
                onChanged: data.data1.isEnable ? (text) {
                  widget.bone.inTmpValue(_toTranslations());
                } : null,
                decoration: widget.decoration.decoration.copyWith(
                  errorText: widget.nosy(data.data2)?.text,
                ),
                maxLines: widget.decoration.maxLines,
                minLines: widget.decoration.maxLines,
              );
            }, stream: widget.bone.outSheetAndError);
          },
        ),
      ],
    );
  }
}


class TranslationsFieldValidator {
  static List<FieldValidator<Translations>> get base => [validator];

  static Future<FieldError> validator(Translations translations) async {
    if (translations == null || translations.isUndefined)
      return TranslationsFieldError.undefined;
    return null;
  }
}


class TranslationsFieldError {
  static const FieldError undefined = FieldError.undefined;
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