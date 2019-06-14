import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/bloc/FocusHandler.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheStreamBuilder.dart';
import 'package:easy_blocs/src/translator/Translator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';


class DateTimeField extends StatelessWidget {
  final DateTimeCheckerRule checker;
  final Hand hand;
  final Translator translator;
  final InputDecoration decoration;
  final DateFormat format;
  final InputType inputType;
  final bool editable;
  final IconData resetIcon;
  final DateTime initialDate, firstDate, lastDate;
  final TimeOfDay initialTime;

  DateTimeField({Key key,
    @required this.checker, @required this.hand, this.translator: dateTimeTranslator,
    this.decoration: const InputDecoration(),

    @required this.format, this.inputType, this.editable: false, this.resetIcon,
    this.initialDate, this.firstDate, this.lastDate, this.initialTime,
  }) : assert(translator != null), super(key: key,);

  DateTimeField.date({Key key,
    @required DateTimeCheckerRule checker, @required Hand hand, Translator translator: dateTimeTranslator,
    InputDecoration decoration: DATE_DECORATION,

    bool editable: false, IconData resetIcon,
  }) : this(
    checker: checker, hand: hand, translator: translator,
    decoration: decoration,
    inputType: InputType.date, format: DateFormat('MM-dd'),
  );

  DateTimeField.time({Key key,
    @required DateTimeCheckerRule checker, @required Hand hand, Translator translator: dateTimeTranslator,
    InputDecoration decoration: TIME_DECORATION,

    bool editable: false, IconData resetIcon,
  }) : this(
    checker: checker, hand: hand, translator: translator,
    decoration: decoration,
    inputType: InputType.time, format: DateFormat('HH:mm'),
  );

  Future<T> _securePicker<T>(BuildContext context, AsyncValueGetter<T> asyncFunction) {
    if (checker.lock.locked)
      return null;
    return checker.lock.synchronized(() async {
      print("ENTER");
      final res = await asyncFunction();
      print("NEXT");
      hand.nextFinger(context, checker);
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder(
      stream: checker.outData,
      builder: (context, snap) {

        final data = snap.data;

        return DateTimePickerFormField(
          format: format,
          inputType: inputType,
          editable: editable,
          resetIcon: resetIcon,

          initialValue: data.value,
          focusNode: checker.focusNode,
          decoration: decoration.copyWith(
            errorText: translator(snap.data.error)?.text,
          ),

          obscureText: data.obscureText,

          onFieldSubmitted: (_) => hand.nextFinger(context, checker),
          onSaved: checker.onSaved,
          validator: (value) => translator(checker.validate(value))?.text,

          datePicker: (_context) => _securePicker(_context, () {
            return showDatePicker(
              context: _context,
              firstDate: checker.firstDate,
              lastDate: checker.lastDate,
              initialDate: initialDate ?? DateTime.now(),
              initialDatePickerMode: DatePickerMode.day,
              //locale: widget.locale,
              //selectableDayPredicate: widget.selectableDayPredicate,
              //textDirection: widget.textDirection,
              //builder: widget.widgetBuilder,
            );
          }),
          timePicker: (_context) => _securePicker(_context, () {
            return showTimePicker(
              context: _context,
              //builder: ,
              initialTime: initialTime ?? TimeOfDay.now(),
            );
          }),

        );
      },
    );
  }
}

const DATE_DECORATION = const InputDecoration(
  suffixIcon: Icon(Icons.calendar_today),
), TIME_DECORATION = const InputDecoration(
  suffixIcon: Icon(Icons.access_time),
);


Translations dateTimeTranslator(Object error) {
  switch (error) {
    case DateTimeFieldError.EMPTY:
      return const TranslationsConst(
        it: "Campo Vuoto",
        en: "Empty Field"
      );
    default:
      return null;
  }
}