import 'dart:async';

import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart'
    show DateTimePickerMode, DatePicker;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' show DateTimeField;
import 'package:intl/intl.dart' show DateFormat;
import 'package:rxdart/rxdart.dart';


class DateTimeFieldSheet {
  final FieldError error;
  final bool enable, readOnly;

  const DateTimeFieldSheet({
    this.error,
    this.enable: true,
    this.readOnly: true,
  });

  DateTimeFieldSheet copyWith({
    FieldError error,
    bool isEnable,
    bool readOnly,
  }) {
    return DateTimeFieldSheet(
      error: error,
      enable: isEnable??this.enable,
      readOnly: readOnly??this.readOnly,
    );
  }
}


abstract class DateTimeFieldBone extends FieldBone<DateTime> {
  Stream<DateTime> get outValue;
  Stream<DateTimeFieldSheet> get outSheet;

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
  }) :
        assert(pickerMode != null),
        assert(validator != null), super(
    validators: validators??DateTimeFieldValidator.base,
  ) {
    validators.addAll([
      if (pickerMode == DateTimePickerMode.datetime)
        ...[validator.defaultValidator, validator.validateDataWithTime, validator.validateTimeWithTime],
    ]);
  }

  @override
  void dispose() {
    _valueController.close();
    _tmpValueController.close();
    _sheetController.close();
    super.dispose();
  }

  final BehaviorSubject<DateTime> _valueController = BehaviorSubject();
  Stream<DateTime> get outValue => _valueController;
  DateTime get value => _valueController.value;
  @override
  void onInValue(DateTime value) => _valueController.add(value);

  final BehaviorSubject<DateTime> _tmpValueController = BehaviorSubject();
  Stream<DateTime> get outTmpValue => _tmpValueController;
  @override
  DateTime get tmpValue => _tmpValueController.value;
  @override
  void inTmpValue(DateTime tmpValue) => _tmpValueController.add(tmpValue);

  final BehaviorSubject<DateTimeFieldSheet> _sheetController = BehaviorSubject();
  Stream<DateTimeFieldSheet> get outSheet => _sheetController;
  DateTimeFieldSheet get sheet => _sheetController.value;
  void inSheet(DateTimeFieldSheet sheet) => _sheetController.add(sheet);
  @override
  void inError(FieldError error) => inSheet(sheet.copyWith(error: error));
  @override
  void inFieldState(FieldState state) => inSheet(sheet.copyWith(isEnable: state == FieldState.active));

  void onSave() => _valueController.add(tmpValue);
}


class DateTimeFieldShell<B extends DateTimeFieldBone> extends StatefulWidget implements FieldShell, FocusShell {
  final B bone;
  final DateTimeFieldSheet sheet;
  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  final DateFormat format;
  final Icon resetIcon;

  DateTimeFieldShell({Key key,
    @required this.bone, @required this.sheet,
    this.mapFocusBone, this.focusNode,

    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),

    DateFormat format,
    this.resetIcon,
  }) :
        this.format = format??(bone.pickerMode == DateTimePickerMode.datetime
            ? DateFormat("MM-dd HH:mm")
            : (bone.pickerMode == DateTimePickerMode.date
            ? DateFormat('aaaa-MM-dd')
            : DateFormat('HH:mm'))),
        assert(bone != null),  assert(sheet != null), super(key: key);

  static Translations nosey(FieldError error) {
    switch (error.code) {

    }
  }

  @override
  _DateTimeFieldShellState createState() => _DateTimeFieldShellState();
}



class _DateTimeFieldShellState extends State<DateTimeFieldShell> with FieldStateMixin, FocusShellStateMixin {
  final TextEditingController _controller = TextEditingController();

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _initListener();
  }

  @override
  void didUpdateWidget(DateTimeFieldShell<DateTimeFieldBone> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _subscription.cancel();
      _initListener();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  void _initListener() {
    _subscription = widget.bone.outValue.distinct().listen(_valueListener);
  }

  void _valueListener(DateTime value) {
    _controller.text = widget.format.format(value);
  }

  @override
  Widget build(BuildContext context) {

    return DateTimeField(
      focusNode: focusNode,

      controller: _controller,
      format: widget.format,
      enabled: widget.sheet.enable,
      readOnly: true,

      onChanged: widget.bone.inTmpValue,
      onFieldSubmitted: (_) => nextFocus(),

      onShowPicker: (_context, currentValue) async {
        Completer<DateTime> completer = Completer();

        DatePicker.showDatePicker(_context,
          dateFormat: '${widget.format.pattern}',
          minDateTime: widget.bone.validator.getMinDateTime(),
          maxDateTime: widget.bone.validator.getMaxDateTime(),
          initialDateTime: currentValue,
          pickerMode: widget.bone.pickerMode,
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

        return await completer.future;
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

  static Future<FieldError> notEmpty(DateTime value) async{
    if (value == null)
      return FieldError(DateTimeFieldError.empty);
    return null;
  }

  final ValueGetter<DateTime> getMinDateTime;
  final ValueGetter<DateTime> getMaxDateTime;

  DateTimeFieldValidator({
    this.getMinDateTime: _getMinDateTime, this.getMaxDateTime: _getMaxDateTime,
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
      hours: 59-value.hour, seconds: 59-value.second,
      milliseconds: 999-value.millisecond, microseconds: 999-value.microsecond,
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
  static const empty = "EMPTY";
  static const before = "BEFORE";
  static const after = "AFTER";
}

//const DATE_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.calendar_today),
//), TIME_DECORATION = const InputDecoration(
//  suffixIcon: Icon(Icons.access_time),
//);