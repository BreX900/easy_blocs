import 'dart:async';

import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart'
    show DateTimePickerMode, DatePicker;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' show DateTimeField;
import 'package:intl/intl.dart' show DateFormat;


class DateTimeFieldSheet {
  final bool enable, readOnly;

  const DateTimeFieldSheet({
    this.enable: true,
    this.readOnly: true,
  });

  DateTimeFieldSheet copyWith({
    bool enable,
    bool readOnly,
  }) {
    return DateTimeFieldSheet(
      enable: enable??this.enable,
      readOnly: readOnly??this.readOnly,
    );
  }
}


abstract class DateTimeFieldBone extends FieldBone<DateTime> {
  DateTimeFieldSheet shield;

  ValueGetter<DateTime> get getMinDateTime;
  ValueGetter<DateTime> get getMaxDateTime;
}


class DateTimeFieldSkeleton extends FieldSkeleton<DateTime> implements DateTimeFieldBone {
  @override
  ValueGetter<DateTime> getMinDateTime;
  @override
  ValueGetter<DateTime> getMaxDateTime;

  DateTimeFieldSkeleton({
    DateTime value,
    List<FieldValidator<DateTime>> validators,
    this.getMinDateTime: _getMinDateTime, this.getMaxDateTime: _getMaxDateTime,
    bool addDefaultValidators: true,
  }) : super(
    value: value, validators: validators??[DateTimeFieldValidator.notEmpty],
  ) {
    if (addDefaultValidators)
      this.validators.add(DateTimeFieldValidator(
        getMinDateTime: getMinDateTime, getMaxDateTime: getMaxDateTime,
      ).defaultValidator);
  }

  DateTimeFieldSheet _shield;
  DateTimeFieldSheet get shield => _shield;
  set shield(DateTimeFieldSheet shield) {
    if (_shield != shield) {
      _shield = shield;
      notifyListeners();
    }
  }

  static DateTime _getMinDateTime() => null;
  static DateTime _getMaxDateTime() => null;
}


class DateTimeFieldShell<B extends DateTimeFieldBone> extends StatefulWidget implements FocusShell {
  final B fieldBone;
  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  final DateTimePickerMode pickerMode;
  final DateFormat format;
  final Icon resetIcon;

  DateTimeFieldShell({Key key,
    @required this.fieldBone,
    this.mapFocusBone, this.focusNode,

    this.nosy: nosey, this.decoration: const InputDecoration(),

    this.pickerMode: DateTimePickerMode.datetime, DateFormat format,
    this.resetIcon,
  }) : this.format = format??DateFormat("MM-dd HH:mm"), super(key: key);

  DateTimeFieldShell.date({Key key,
    @required DateTimeFieldBone fieldBone,
    MapFocusBone mapFocusBone, FocusNode focusNode,

    InputDecoration decoration,
  }) : this(
    fieldBone: fieldBone,
    mapFocusBone: mapFocusBone, focusNode: focusNode,
    decoration: decoration,
    pickerMode: DateTimePickerMode.date, format: DateFormat('aaaa-MM-dd'),
  );

  DateTimeFieldShell.time({Key key,
    @required DateTimeFieldBone fieldBone,
    MapFocusBone mapFocusBone, FocusNode focusNode,

    InputDecoration decoration,
  }) : this(
    fieldBone: fieldBone,
    mapFocusBone: mapFocusBone, focusNode: focusNode,
    decoration: decoration,
    pickerMode: DateTimePickerMode.time, format: DateFormat('HH:mm'),
  );

  static Translations nosey(FieldError error) {
    switch (error.code) {

    }
  }

  @override
  _DateTimeFieldShellState createState() => _DateTimeFieldShellState();
}



class _DateTimeFieldShellState extends State<DateTimeFieldShell> with FocusShellStateMixin {

  DateTimeFieldBone get bone => widget.fieldBone;

  @override
  Widget build(BuildContext context) {

    return DateTimeField(
      format: widget.format,
      focusNode: focusNode,
      enabled: bone.shield.enable,
      readOnly: true,

      initialValue: bone.value,

      validator: (value) => widget.nosy(bone.validator(value))?.text,
      onSaved: bone.onSaved,
      onFieldSubmitted: (_) => nextFocus(),

      onShowPicker: (_context, currentValue) async {
        Completer<DateTime> completer = Completer();

        DatePicker.showDatePicker(_context,
          dateFormat: '${widget.format.pattern}',
          minDateTime: bone.getMinDateTime(),
          maxDateTime: bone.getMaxDateTime(),
          initialDateTime: currentValue,
          pickerMode: widget.pickerMode,
          onCancel: () {
            completer.complete(null);
          },
          onClose: () {
            if (!completer.isCompleted)
              completer.complete();
          },
          onConfirm: (datetime, list) {
            completer.complete(datetime);
          },
        );

        return await completer.future;//await Future.delayed(Duration(milliseconds: 300)).then((_) => completer.future);
      },
    );
  }
}

class DateTimeFieldValidator {
  static const List<FieldValidator<DateTime>> base =  [
    notEmpty,
  ];

  static FieldError notEmpty(DateTime value) {
    if (value == null)
      return FieldError(DateTimeFieldError.empty);
    return null;
  }

  final ValueGetter<DateTime> getMinDateTime;
  final ValueGetter<DateTime> getMaxDateTime;

  DateTimeFieldValidator({
    @required this.getMinDateTime, @required this.getMaxDateTime,
  }) : assert(getMinDateTime != null && getMaxDateTime != null);

  FieldError defaultValidator(DateTime value) {
    if (value.isBefore(getMinDateTime()))
      return FieldError(DateTimeFieldError.before, getMinDateTime());
    if (value.isAfter(getMaxDateTime()))
      return FieldError(DateTimeFieldError.after, getMaxDateTime());
    return null;
  }


  DateTime _tmpData;

  FieldError validateData(DateTime value) {
    _tmpData = value.add(Duration(
      hours: 59-value.hour, seconds: 59-value.second,
      milliseconds: 999-value.millisecond, microseconds: 999-value.microsecond,
    ));
    return defaultValidator(value);
  }

  FieldError validateTime(DateTime value) {
    assert(_tmpData != null, "Before validating the Time valid the Data");
    _tmpData = DateTimeUtility.byDateAndTime(_tmpData, value);
    final error = defaultValidator(value);
    _tmpData = null;
    return error;
  }
}
class DateTimeFieldError {
  static const empty = "EMPTY";
  static const before = "BEFORE";
  static const after = "AFTER";
}

//const DATE_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.calendar_today),
//), TIME_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.access_time),
//);