import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' as dtf;
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class DateTimeField extends StatelessWidget {
  final DateTimeCheckerRule checker;
  final Translator translator;
  final InputDecoration decoration;
  final DateTimePickerMode pickerMode;
  final DateFormat format;
  final bool editable;
  final Icon resetIcon;
  final DateTime initialDate, firstDate, lastDate;
  final TimeOfDay initialTime;

  DateTimeField({
    Key key,
    @required this.checker,
    this.translator: dateTimeTranslator,
    this.decoration: const InputDecoration(),
    this.pickerMode: DateTimePickerMode.datetime,
    @required this.format,
    this.editable: true,
    this.resetIcon,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.initialTime,
  })  : assert(translator != null),
        super(
          key: key,
        );

  DateTimeField.date({
    Key key,
    @required DateTimeCheckerRule checker,
    Translator translator: dateTimeTranslator,
    InputDecoration decoration: DATE_DECORATION,
    bool editable: false,
    IconData resetIcon,
  }) : this(
          checker: checker,
          translator: translator,
          decoration: decoration,
          pickerMode: DateTimePickerMode.datetime,
          format: DateFormat('MM-dd'),
        );

  DateTimeField.time({
    Key key,
    @required DateTimeCheckerRule checker,
    Translator translator: dateTimeTranslator,
    InputDecoration decoration: TIME_DECORATION,
    bool editable: false,
    IconData resetIcon,
  }) : this(
          checker: checker,
          translator: translator,
          decoration: decoration,
          pickerMode: DateTimePickerMode.time,
          format: DateFormat('HH:mm'),
        );

//  Future<T> _securePicker<T>(BuildContext context, AsyncValueGetter<T> asyncFunction) {
//    if (checker.lock.locked)
//      return null;
//    return checker.lock.synchronized(() async {
//      final res = await asyncFunction();
//      checker.nextFinger(context);
//      return res;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder(
      stream: checker.outData,
      builder: (context, snap) {
        return dtf.DateTimeField(
          format: format,
          focusNode: checker.focusNode,
//          enabled: editable,
//          decoration: decoration.copyWith(
//            errorText: translator(snap.data.error)?.text,
//          ),
//          obscureText: data.obscureText,
//          onFieldSubmitted: (_) => checker.nextFinger(context),
//
//          readOnly: true,
//
//          resetIcon: resetIcon,
//          enableInteractiveSelection: true,
//
//          initialValue: data.value,
//
//          onSaved: checker.onSaved,
//          validator: (value) => translator(checker.validate(value))?.text,
          readOnly: true,
          onShowPicker: (_context, currentValue) async {
            Completer<DateTime> completer = Completer();

            DatePicker.showDatePicker(
              _context,
              minDateTime: checker.firstDate,
              maxDateTime: checker.lastDate,
              initialDateTime: currentValue,
              pickerMode: pickerMode,
              onCancel: () {
                completer.complete(null);
              },
              onClose: () {
                if (!completer.isCompleted) completer.complete();
              },
              onConfirm: (datetime, list) {
                completer.complete(datetime);
              },
            );

            return await Future.delayed(Duration(milliseconds: 300)).then((_) =>
                completer.future); //.whenComplete(() => Future.delayed(Duration(milliseconds: 300))
            // .whenComplete(() => checker.nextFinger(_context)));
          },
        );
      },
    );
  }
}

const DATE_DECORATION = const InputDecoration(
  suffixIcon: Icon(Icons.calendar_today),
),
    TIME_DECORATION = const InputDecoration(
  suffixIcon: Icon(Icons.access_time),
);

Translations dateTimeTranslator(Object error) {
  switch (error) {
    case DateTimeFieldErrors.EMPTY:
      return const TranslationsConst(it: "Campo Vuoto", en: "Empty Field");
    default:
      return null;
  }
}
