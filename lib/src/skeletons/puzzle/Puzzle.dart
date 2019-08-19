//import 'dart:async';
//
//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/puzzle/Piece.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';
//
//abstract class ArrisEvent implements ReqResEvent { const ArrisEvent(); }
//class EnableArrisEvent extends ArrisEvent { const EnableArrisEvent() : super(); }
//class WorkingArrisEvent extends ArrisEvent { const WorkingArrisEvent() : super(); }
//class DisableArrisEvent extends ArrisEvent { const DisableArrisEvent() : super(); }
//
//abstract class ArrisBoneBase {
//  Stream<ReqResEvent> get outPieceEvent;
//}
//mixin ArrisSkeletonMixin implements ArrisBoneBase {
//  final BehaviorSubject<ReqResEvent> _stateController = BehaviorSubject.seeded(const EnableArrisEvent(), sync: true);
//  Stream<ReqResEvent> get outPieceEvent => _stateController;
//  Future<void> inArrisEvent(ArrisEvent state) async => _stateController.add(state);
//}
//
//abstract class ArrisBase extends StatefulWidget {
//  Stream<ArrisEvent> get outArrisEvent;
//  ValueSetter<ArrisEvent> get inArrisEvent;
//}
//mixin ArrisStateMixin<WidgetType extends ArrisBase> on State<WidgetType> {
//  StreamSubscription<ArrisEvent> subscription;
//
//  @override
//  void initState() {
//    super.initState();
//    subscription = widget.outArrisEvent.listen(arrisEventListener);
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.outArrisEvent != oldWidget.outArrisEvent) {
//      subscription.cancel();
//      subscription = widget.outArrisEvent.listen(arrisEventListener);
//    }
//  }
//  void arrisEventListener(ArrisEvent event);
//}
//
//
//
//
//abstract class ButtonBone {
//  Stream<bool> get outState;
//  Future<void> inTap();
//}
//class ButtonSkeleton implements ButtonBone{
//  AsyncCallback onPressed;
//
//  BehaviorSubject<bool> _stateController = BehaviorSubject();
//  Stream<bool> get outState => _stateController;
//
//  @override
//  Future<void> inTap() {
//    _stateController.add(null);
//    onPressed().whenComplete(() {
//      _stateController.add(false);
//    });
//  }
//}
//class ButtonShell extends StatefulWidget {
//  final ButtonBone bone;
//
//  const ButtonShell({Key key, this.bone}) : super(key: key);
//
//  @override
//  _ButtonShellState createState() => _ButtonShellState();
//}
//
//class _ButtonShellState extends State<ButtonShell> {
//  @override
//  Widget build(BuildContext context) {
//    return RaisedButton(
//      onPressed: widget.bone.inTap,
//    );
//  }
//}
//
//
//
//
//
//
//
//class SubmitEvent { const SubmitEvent(); }
//
//
//abstract class SubmitBone implements PieceBoneBase {
//  Stream<ArrisEvent> get outPieceEvent;
//}
//
//class SubmitSkeleton extends Skeleton implements SubmitBone, PieceBoneBase {
//  AsyncCallback onSubmit;
//
//  @override
//  Future<void> inSubmitEvent(SubmitEvent event) async {
//    await inArrisEvent(const WorkingArrisEvent());
//    try {
//      onSubmit();
//    } catch(exc) {
//      await inArrisEvent(const EnableArrisEvent());
//    }
//  }
//
//  @override
//  Future<bool> validation() {
//
//  }
//
//  @override
//  Future<void> save() {
//    // TODO: implement save
//    return null;
//  }
//}
//
//
//class SubmitButtonPuzzle extends StatefulWidget {
//  final Stream<ArrisEvent> outEvent;
//  final ValueSetter<SubmitEvent> inEvent;
//
//  const SubmitButtonPuzzle({Key key,
//    @required this.outEvent, @required this.inEvent,
//  }) : super(key: key);
//  @override
//  _SubmitButtonPuzzleState createState() => _SubmitButtonPuzzleState();
//}
//
//class _SubmitButtonPuzzleState extends State<SubmitButtonPuzzle> {
//  PuzzleController _controller;
//  StreamSubscription _subscription;
//  ArrisEvent _event;
//
//  @override
//  void initState() {
//    _subscription = widget.outEvent.listen(eventListener);
//    super.initState();
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _controller?.removeArris(widget.bone);
//    _controller = Puzzle.of(context);
//    _controller.addArris(widget.bone);
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.bone != oldWidget.bone) {
//      _controller.removeArris(oldWidget.bone);
//      _subscription?.cancel();
//      _subscription = widget.bone.outPieceEvent.listen(eventListener);
//      _controller.addArris(widget.bone);
//    }
//  }
//
//  @override
//  void dispose() {
//    _subscription.cancel();
//    super.dispose();
//  }
//
//  void eventListener(ArrisEvent event) {
//    setState(() => _event = event);
//  }
//
//  void _onPressed() {
//    Puzzle.of(context).submit(widget.bone.onSubmit);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (_event is WorkingArrisEvent)
//      return CircularProgressIndicator();
//
//    return RaisedButton(
//      onPressed: _event is DisableArrisEvent ? null : _onPressed,
//    );
//  }
//}
//
//
//
//abstract class PieceBoneBase {
//  Future<bool> validation();
//  Future<void> save();
//}
//
//
//
///// PUZZLE CONTROLLER
//class PuzzleEvent { const PuzzleEvent(); }
//class ValidationPuzzleEvent extends PuzzleEvent implements WorkingArrisEvent { const ValidationPuzzleEvent(); }
//class SavedPuzzleEvent extends PuzzleEvent implements WorkingArrisEvent { const SavedPuzzleEvent(); }
//
//class PuzzleController {
//  final List<PieceBoneBase> _pieces;
//  final ArrisSkeleton _arrisController;
//
//  PuzzleController(this._arrisController);
//
//  Future<bool> validate() async {
//    bool isValid = true;
//    _pieces.map((piece) async {
//      final res = await piece.validation();
//      if (!res)
//        isValid = false;
//    });
//
//    if (!isValid)
//      _arrisController.inArrisEvent(const EnableArrisEvent());
//
//    return isValid;
//  }
//
//  Future<void> save() async {
//
//    _arrisController.inArrisEvent(event)
//
//    _event = const SavedPuzzleEvent();
//
//    await Future.wait(_arris.map((piece) => piece is PieceBone ? piece._save() : null));
//  }
//
//  Future<void> submit(Future<bool> submitter()) => validate().then((res) async {
//    if (res)
//      await save();
//    try {
//      await submitter();
//      _event = const DisableArrisEvent();
//    } catch(event) {
//      if (event is ArrisEvent)
//        _event = event;
//    }
//    return null;
//  });
//}
//
//
///// PUZZLE
//
//class Puzzle extends StatefulWidget {
//  final Widget child;
//
//  const Puzzle({Key key, this.child}) : super(key: key);
//
//  @override
//  _PuzzleState createState() => _PuzzleState();
//
//  static PuzzleController of(BuildContext context) {
//    return _Puzzle.of(context);
//  }
//}
//
//class _PuzzleState extends State<Puzzle> {
//  PuzzleController _controller = PuzzleController();
//
//  @override
//  Widget build(BuildContext context) {
//    return _Puzzle(
//      controller: _controller,
//      child: widget.child,
//    );
//  }
//}
//
//
//class _Puzzle extends InheritedWidget {
//  final PuzzleController controller;
//
//  const _Puzzle({
//    Key key,
//    @required this.controller,
//    @required Widget child,
//  })
//      : assert(child != null),
//        super(key: key, child: child);
//
//  static PuzzleController of(BuildContext context) {
//    return (context.inheritFromWidgetOfExactType(_Puzzle) as _Puzzle).controller;
//  }
//
//  @override
//  bool updateShouldNotify(_Puzzle old) {
//    return controller != old.controller;
//  }
//}
//
//
//class ArrisSkeleton {
//  final List<ArrisBase> _arris = [];
//
//  Future<void> inArrisEvent(Event event) async {
//    _arris.forEach((arris) => arris.inArrisEvent(event));
//  }
//
//  void addArris(ArrisBoneBase piece) => _arris.add(piece);
//  void removeArris(ArrisBoneBase piece) => _arris.remove(piece);
//}