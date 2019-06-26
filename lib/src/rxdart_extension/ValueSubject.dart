import 'dart:async';

import 'package:rxdart/rxdart.dart';

class ValueSubject<T> extends Subject<T> {
  ValueSubject._(StreamController<T> controller, Observable<T> observable) : super(controller, observable);
  
  factory ValueSubject({void onListen(), void onCancel(), bool sync = false}) {
    BehaviorSubject();
    
    return ValueSubject._(
      StreamController<T>.broadcast(onListen: onListen, onCancel: onCancel),
      Observable<T>.defer(() {

      }),
    );
  }
}