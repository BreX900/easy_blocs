import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';


class DateTimeChecker extends Checker<DateTime, DateTime> implements DateTimeCheckerRule {
  final Lock lock = Lock(reentrant: true);

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final TimeOfDay initialTime;

  DateTimeChecker({@required Hand hand,
    this.initialDate, DateTime firstDate, DateTime lastDate, this.initialTime
  }) : this.firstDate = firstDate??DateTime(1900), this.lastDate = lastDate??DateTime(2100),
        super(hand: hand);

  TimeOfDay get time => TimeOfDay(hour: value.hour, minute: value.minute);

  @override
  Object validate(DateTime val) {
    if (val == null)
      return DateTimeFieldError.EMPTY;
    return null;
  }

  @override
  void onSaved(DateTime val) {
    add(data.copyWith(value: val));
  }

  bool _isInPicking = false;
  bool get isInPicking => _isInPicking;
  void lockPicking() => _isInPicking = true;
  void unlockPicking() => _isInPicking = false;

}


abstract class DateTimeCheckerRule extends FingerNode {
  Lock get lock;

  Stream<DataField<DateTime>> get outData;

  bool get isInPicking;

  Object validate(DateTime dateTime);

  void onSaved(DateTime dateTime);

  DateTime get initialDate;
  DateTime get firstDate;
  DateTime get lastDate;
  TimeOfDay get initialTime;
}


enum DateTimeFieldError {
  EMPTY,
  INVALID,
}

