import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


abstract class ArrisBone {
  //Stream<ArrisEvent> get outEvent;
  //ArrisEvent get event;
  set _event(ArrisEvent state);
}


mixin ArrisSkeleton implements ArrisBone {
  final BehaviorSubject<ArrisEvent> _stateController = BehaviorSubject.seeded(const EnableArrisEvent(), sync: true);
  Stream<ArrisEvent> get outEvent => _stateController;
  //ArrisEvent get event => _stateController.value;
  set _event(ArrisEvent state) => _stateController.add(state);
}

abstract class SubmitBone implements ArrisBone {
  Stream<ArrisEvent> get outEvent;
  AsyncCallback get onSubmit;
}

class SubmitSkeleton {
  AsyncCallback onSubmit;
}


class SubmitButtonPuzzle extends StatefulWidget {
  final SubmitBone bone;

  const SubmitButtonPuzzle({Key key, @required this.bone}) : super(key: key);
  @override
  _SubmitButtonPuzzleState createState() => _SubmitButtonPuzzleState();
}

class _SubmitButtonPuzzleState extends State<SubmitButtonPuzzle> {
  PuzzleController _controller;
  StreamSubscription _subscription;
  ArrisEvent _event;

  @override
  void initState() {
    _subscription = widget.bone.outEvent.listen(eventListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller?.removeArris(widget.bone);
    _controller = Puzzle.of(context);
    _controller.addArris(widget.bone);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _controller.removeArris(oldWidget.bone);
      _subscription?.cancel();
      _subscription = widget.bone.outEvent.listen(eventListener);
      _controller.addArris(widget.bone);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void eventListener(ArrisEvent event) {
    setState(() => _event = event);
  }

  void _onPressed() {
    Puzzle.of(context).submit(widget.bone.onSubmit);
  }

  @override
  Widget build(BuildContext context) {
    if (_event is WorkingArrisEvent)
      return CircularProgressIndicator();

    return RaisedButton(
      onPressed: _event is CompletedArrisEvent ? null : _onPressed,
    );
  }
}

class PieceSheet<V> {
  final ArrisEvent event;
  final V value;
  final PieceError error;

  const PieceSheet({this.event, this.value, this.error});

  PieceSheet<V> copyWith({ArrisEvent event, V value, PieceError error}) {
    return PieceSheet<V>(
      event: event??this.event,
      value: value??this.value,
      error: error,
    );
  }
}

typedef String PieceErrorTranslator(PieceError error);
class PieceError<V> {
  String code;
  String message;
  V arg;
}
typedef Future<PieceError> PieceValidator<V>(V value);


abstract class Piece<S extends PieceSheet<V>, V> implements StatefulWidget {
  PieceBone<S, V> get bone;
  PieceErrorTranslator get translator;
}
mixin PieceStateMixin<WidgetType extends Piece<S, V>, S extends PieceSheet<V>, V>
    on State<WidgetType> {

  PuzzleController _controller;
  CompositeSubscription _subscriptions = CompositeSubscription();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller?.removeArris(widget.bone);
    _controller = Puzzle.of(context);
    _controller.addArris(widget.bone);
    _initListeners();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _subscriptions.clear();
      _controller.removeArris(oldWidget.bone);
      _controller.addArris(widget.bone);
      _initListeners();
    }
  }

  void _initListeners() {
    _subscriptions.add(widget.bone.outSheet.listen(sheetListener));
  }
  void sheetListener(S sheet);

  Future<void> inTmpValue(V tmpValue) => widget.bone.inTmpValue(tmpValue);
}


abstract class PieceBone<S extends PieceSheet<V>, V> implements ArrisBone {
  //ArrisEvent get event;
  //Stream<ArrisEvent> get outEvent;
  //V get tmpValue;
  //Stream<V> get outTmpValue;
  Future<void> inTmpValue(V tmpValue);
  //PieceError get error;
  //Stream<PieceError> get outError;
  Stream<S> get outSheet;
  Future<bool> _validation();
  Future<void> _save();
}
class PieceSkeleton<S extends PieceSheet<V>, V> with ArrisSkeleton implements PieceBone<S, V>  {
  final BehaviorSubject<V> _tmpValueController;
  Stream<V> get outTmpValue => _tmpValueController;
  V get tmpValue => _tmpValueController.value;
  Future<void> inTmpValue(V value) async => _tmpValueController.add(value);

  V _value;
  V get value => _value;

  final BehaviorSubject<PieceError> _errorController = BehaviorSubject();
  Stream<PieceError> get outError => _errorController;
  PieceError get error => _errorController.value;

  final BehaviorSubject<S> _sheetController = BehaviorSubject();
  Stream<S> get outSheet => _sheetController;

  final List<PieceValidator<V>> _validators;

  PieceSkeleton({
    V seed,
    List<PieceValidator<V>> validators,
  }) : _value = seed, _tmpValueController = BehaviorSubject.seeded(seed),
        this._validators = validators??[];

  Future<bool> _validation() => validation();
  Future<bool> validation() async {
    for (PieceValidator<V> validator in _validators) {
      final _error = await validator(tmpValue);
      if (_error != null)
        return false;
    }
    return true;
  }
  Future<void> _save() => save();
  Future<void> save() async => _value = tmpValue;
}

abstract class ArrisEvent { const ArrisEvent(); }
class EnableArrisEvent extends ArrisEvent { const EnableArrisEvent() : super(); }
class WorkingArrisEvent extends ArrisEvent { const WorkingArrisEvent() : super(); }
class CompletedArrisEvent extends ArrisEvent { const CompletedArrisEvent() : super(); }

class ValidationPuzzleEvent extends WorkingArrisEvent { const ValidationPuzzleEvent() : super(); }
class SavedPuzzleEvent extends WorkingArrisEvent { const SavedPuzzleEvent() : super(); }

class PuzzleController {
  List<ArrisBone> _arris = [];

  void addArris(ArrisBone piece) => _arris.add(piece);
  void removeArris(ArrisBone piece) => _arris.remove(piece);

  set _event(ArrisEvent state) => _arris.forEach((arris) => arris._event = state);

  Future<bool> validate() async {
    _event = const ValidationPuzzleEvent();
    bool isValid = true;
    await Future.wait(_arris.map((piece) => piece is PieceBone ? piece._validation().then((res) {
      if (!res)
        isValid = false;
    }) : null));

    if (!isValid)
      _event = const EnableArrisEvent();

    return isValid;
  }

  Future<void> save() async {
    _event = const SavedPuzzleEvent();
    await Future.wait(_arris.map((piece) => piece is PieceBone ? piece._save() : null));
  }

  Future<void> submit(Future<bool> submitter()) => validate().then((res) async {
    if (res)
      await save();
    try {
      await submitter();
      _event = const CompletedArrisEvent();
    } catch(event) {
      if (event is ArrisEvent)
        _event = event;
    }
    return null;
  });
}


class Puzzle extends StatefulWidget {
  final Widget child;

  const Puzzle({Key key, this.child}) : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();

  static PuzzleController of(BuildContext context) {
    return _Puzzle.of(context);
  }
}

class _PuzzleState extends State<Puzzle> {
  PuzzleController _controller = PuzzleController();

  @override
  Widget build(BuildContext context) {
    return _Puzzle(
      controller: _controller,
      child: widget.child,
    );
  }
}


class _Puzzle extends InheritedWidget {
  final PuzzleController controller;

  const _Puzzle({
    Key key,
    @required this.controller,
    @required Widget child,
  })
      : assert(child != null),
        super(key: key, child: child);

  static PuzzleController of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_Puzzle) as _Puzzle).controller;
  }

  @override
  bool updateShouldNotify(_Puzzle old) {
    return controller != old.controller;
  }
}
