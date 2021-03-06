import 'dart:async';

import 'package:easy_blocs/src/repository/RepositoryBloc.dart';
import 'package:easy_blocs/src/rxdart/Data.dart';
import 'package:easy_blocs/src/rxdart/ObservableBuilder.dart';
import 'package:easy_blocs/src/skeletons/Focuser.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart'
    show DatePicker, DateTimePickerLocale, DateTimePickerMode;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' show DateTimeField;
import 'package:intl/intl.dart' show DateFormat;
import 'package:rxdart/rxdart.dart';

class DateTimeFieldSheet {
  final bool isEnable, readOnly;

  const DateTimeFieldSheet({
    this.isEnable: true,
    this.readOnly: true,
  });

  DateTimeFieldSheet copyWith({
    bool isEnable,
    bool readOnly,
  }) {
    return DateTimeFieldSheet(
      isEnable: isEnable ?? this.isEnable,
      readOnly: readOnly ?? this.readOnly,
    );
  }
}

abstract class DateTimeFieldBone extends FieldBone<DateTime> {
  Stream<DateTimeFieldSheet> get outSheet;
  Stream<Data2<FieldError, DateTimeFieldSheet>> get outErrorAndSheet;

  DateTimePickerMode get pickerMode;
  DateTimeFieldValidator get validator;
}

class DateTimeFieldSkeleton extends FieldSkeleton<DateTime> implements DateTimeFieldBone {
  final DateTimePickerMode pickerMode;
  final DateTimeFieldValidator validator;

  DateTimeFieldSkeleton({
    DateTime value,
    this.pickerMode: DateTimePickerMode.datetime,
    @required this.validator,
    List<FieldValidator<DateTime>> validators,
  })  : assert(pickerMode != null),
        assert(validator != null),
        super(
          validators: validators ?? DateTimeFieldValidator.base,
        ) {
    this.validators.addAll([
      if (pickerMode == DateTimePickerMode.datetime) ...[validator.defaultValidator],
    ]);
  }

  @override
  void dispose() {
    _sheetController.close();
    super.dispose();
  }

  final BehaviorSubject<DateTimeFieldSheet> _sheetController =
      BehaviorSubject.seeded(const DateTimeFieldSheet());
  Stream<DateTimeFieldSheet> get outSheet => _sheetController;
  DateTimeFieldSheet get sheet => _sheetController.value;
  void inSheet(DateTimeFieldSheet sheet) => _sheetController.add(sheet);

  Stream<Data2<FieldError, DateTimeFieldSheet>> _outErrorAndSheet;
  Stream<Data2<FieldError, DateTimeFieldSheet>> get outErrorAndSheet {
    if (_outErrorAndSheet == null) _outErrorAndSheet = Data2.combineLatest(outError, outSheet);
    return _outErrorAndSheet;
  }
}

class DateTimeFieldShell<B extends DateTimeFieldBone> extends StatefulWidget
    implements FieldShell, FocusShell {
  final B bone;
  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  final DateFormat format, pickerFormat;
  final Icon resetIcon;

  DateTimeFieldShell({
    Key key,
    @required this.bone,
    this.mapFocusBone,
    this.focusNode,
    this.nosy: nosey,
    this.decoration: const InputDecoration(),
    DateFormat format,
    this.pickerFormat,
    this.resetIcon,
  })  : this.format = format ??
            (bone.pickerMode == DateTimePickerMode.datetime
                ? DateFormat("dd-MM HH:mm")
                : (bone.pickerMode == DateTimePickerMode.date
                    ? DateFormat('dd-MM-aaaa')
                    : DateFormat('HH:mm'))),
        assert(bone != null),
        super(key: key);

  static Translations nosey(FieldError error) {
    switch (error?.code) {
      case DateTimeFieldError.before:
        return TranslationsConst();
      case DateTimeFieldError.after:
        return TranslationsConst();
      default:
        return basicNoisy(error);
    }
  }

  @override
  _DateTimeFieldShellState createState() => _DateTimeFieldShellState();
}

class _DateTimeFieldShellState extends FieldState<DateTimeFieldShell> with FocusShellStateMixin {
  final RepositoryBlocBase _repositoryBloc = RepositoryBlocBase.of();

  final TextEditingController _controller = TextEditingController();

  ObservableSubscriber<DateTime> _valueSubscriber;
  ObservableSubscriber<Data2<FieldError, DateTimeFieldSheet>> _dataSubscriber;

  Data2<FieldError, DateTimeFieldSheet> _data;

  @override
  void initState() {
    super.initState();
    _valueSubscriber = ObservableSubscriber(_valueListener);
    _dataSubscriber = ObservableSubscriber(_dataListener);
    _subscribe();
  }

  @override
  void didUpdateWidget(DateTimeFieldShell<DateTimeFieldBone> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _subscribe();
      _unsubscribe();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _valueSubscriber.subscribe(widget.bone.outValue);
    _dataSubscriber.subscribe(widget.bone.outErrorAndSheet);
  }

  void _unsubscribe() {
    _valueSubscriber.unsubscribe();
    _dataSubscriber.unsubscribe();
  }

  void _dataListener(ObservableState<Data2<FieldError, DateTimeFieldSheet>> update) {
    setState(() => _data = update.data);
  }

  void _valueListener(ObservableState<DateTime> update) {
    _controller.text = update.data == null ? null : widget.format.format(update.data);
  }

  DateTimePickerLocale _getLocale() {
    switch (_repositoryBloc.locale.languageCode) {
      case 'it':
        return DateTimePickerLocale.it;
      default:
        return DateTimePickerLocale.en_us;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      focusNode: focusNode,
      controller: _controller,
      format: widget.format,
      enabled: _data.data2.isEnable,
      readOnly: true,
      onFieldSubmitted: (_) => nextFocus(),
      decoration: widget.decoration.copyWith(
        errorText: widget.nosy(_data.data1)?.text,
        errorMaxLines: widget.decoration.errorMaxLines ?? 2,
      ),
      onShowPicker: (_context, currentValue) async {
        Completer<DateTime> completer = Completer();

        DatePicker.showDatePicker(
          _context,
          dateFormat: '${(widget.pickerFormat ?? widget.format).pattern}',
          minDateTime: widget.bone.validator.getMinDateTime(),
          maxDateTime: widget.bone.validator.getMaxDateTime(),
          initialDateTime: currentValue,
          pickerMode: widget.bone.pickerMode,
          locale: _getLocale(),
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

        return await completer.future.then((res) {
          widget.bone.inTmpValue(res);
          return res;
        });
      },
    );
  }
}

class DateTimeFieldValidator {
  static List<FieldValidator<DateTime>> get base {
    return [
      notEmpty,
    ];
  }

  static Future<FieldError> notEmpty(DateTime value) async {
    if (value == null) return DateTimeFieldError.undefined;
    return null;
  }

  final ValueGetter<DateTime> getMinDateTime;
  final ValueGetter<DateTime> getMaxDateTime;

  DateTimeFieldValidator({
    this.getMinDateTime: _getMinDateTime,
    this.getMaxDateTime: _getMaxDateTime,
  }) : assert(getMinDateTime != null && getMaxDateTime != null);

  Future<FieldError> defaultValidator(DateTime value) async {
    if (value.isBefore(getMinDateTime()))
      return FieldError(DateTimeFieldError.before, getMinDateTime());
    if (value.isAfter(getMaxDateTime()))
      return FieldError(DateTimeFieldError.after, getMaxDateTime());
    return null;
  }

  DateTime _tmpData;

  Future<FieldError> validateDataWithTime(DateTime value) async {
    _tmpData = value.add(Duration(
      hours: 59 - value.hour,
      seconds: 59 - value.second,
      milliseconds: 999 - value.millisecond,
      microseconds: 999 - value.microsecond,
    ));
    return await defaultValidator(value);
  }

  Future<FieldError> validateTimeWithTime(DateTime value) async {
    assert(_tmpData != null, "Before validating the Time valid the Data");
    _tmpData = DateTimeUtility.byDateAndTime(_tmpData, value);
    final error = await defaultValidator(value);
    _tmpData = null;
    return error;
  }

  static DateTime _getMinDateTime() => null;
  static DateTime _getMaxDateTime() => null;
}

class DateTimeFieldError {
  static const FieldError undefined = FieldError.$undefined;
  static const String before = "BEFORE";
  static const String after = "AFTER";
}

//const DATE_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.calendar_today),
//), TIME_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.access_time),
//);
