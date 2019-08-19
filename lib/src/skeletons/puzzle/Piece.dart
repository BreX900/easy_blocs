//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/skeletons/puzzle/Puzzle.dart';
//import 'package:easy_blocs/src/utility.dart';
//import 'package:flutter/widgets.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//abstract class PieceEvent extends ReqResEvent { const PieceEvent(); }
//
//class InValuePieceEvent<V> extends PieceEvent {
//  final V value;
//  const InValuePieceEvent({@required this.value});
//}
//
//class ValidationPieceReq extends Req { const ValidationPieceReq(); }
//class ValidationPieceRes extends Res {
//  final bool res;
//  ValidationPieceRes(this.res);
//}
//class SavePieceReq extends Req { const SavePieceReq(); }
//
//
//class SheetPiece<V> extends PieceEvent {
//  final ArrisEvent event;
//  final V value;
//  final PieceError error;
//
//  const SheetPiece({this.event, this.value, this.error});
//
//  SheetPiece<V> copyWith({ArrisEvent event, V value, PieceError error}) {
//    return SheetPiece<V>(
//      event: event??this.event,
//      value: value??this.value,
//      error: error,
//    );
//  }
//}
//
//
//typedef String PieceErrorTranslator(PieceError error);
//class PieceError<V> {
//  String code;
//  String message;
//  V arg;
//}
//typedef Future<PieceError> PieceValidator<V>(V value);
//
//
//abstract class Piece<S extends SheetPiece<V>, V> implements StatefulWidget {
//  //PieceBone<S, V> get bone;
//  Stream<ReqResEvent> get outEvent;
//  ReqToRes get inReq;
//  PieceErrorTranslator get translator;
//}
//mixin PieceStateMixin<WidgetType extends Piece<S, V>, S extends SheetPiece<V>, V>
//on State<WidgetType> {
//
//  PuzzleController _controller;
//  CompositeSubscription _subscriptions = CompositeSubscription();
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _controller?.removeArris(widget.bone);
//    _controller = Puzzle.of(context);
//    _controller.addArris(widget.bone);
//    _initListeners();
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.bone != oldWidget.bone) {
//      _subscriptions.clear();
//      _controller.removeArris(oldWidget.bone);
//      _controller.addArris(widget.bone);
//      _initListeners();
//    }
//  }
//
//  void _initListeners() {
//    _subscriptions.add(widget.outEvent.where((event) => event is SheetPiece<V>).listen(sheetListener));
//  }
//  void sheetListener(sheet);
//
//  Future<void> inValue(V newValue) async => widget.inEvent(InValuePieceEvent(value: newValue));
//}
//
//
//abstract class PieceBone<S extends SheetPiece<V>, V> implements ArrisBoneBase, PieceBoneBase {
//  Stream<PieceEvent> get outPieceEvent;
//}
//
//class PieceSkeleton<S extends SheetPiece<V>, V> extends Skeleton with ArrisSkeletonMixin implements PieceBone<S, V>  {
//  @override
//  void dispose() {
//    _eventController.close();
//    super.dispose();
//  }
//
//  V _value, _tmpValue;
//  V get value => _value;
//
//  final BehaviorSubject<SheetPiece> _eventController = BehaviorSubject();
//  Stream<SheetPiece> get outPieceEvent => _eventController;
//
//  final List<PieceValidator<V>> _validators;
//
//  PieceSkeleton({
//    V seed,
//    List<PieceValidator<V>> validators,
//  }) : _value = seed, _tmpValue = seed,
//        this._validators = validators??[];
//
//  Future<bool> validation() async {
//    for (PieceValidator<V> validator in _validators) {
//      final _error = await validator(_tmpValue);
//      if (_error != null)
//        return false;
//    }
//    return true;
//  }
//  Future<void> save() async => _value = _tmpValue;
//}