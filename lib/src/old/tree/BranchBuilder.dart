//import 'package:easy_blocs/src/tree/ScrollViews.dart';
//import 'package:flutter/widgets.dart';
//
//
//class BranchBuilder extends StatefulBranch {
//  StreamSubscription<V> _subscription;
//  V _data;
//  Object _state;
//
//  @override
//  void initState() {
//    super.initState();
//    _subscribe();
//  }
//
//  @override
//  void didUpdateWidget(ObservableBuilder<V> oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.stream != widget.stream) {
//      _unsubscribe();
//      _subscribe();
//    }
//  }
//
//  @override
//  List<Widget> buildBranch(BuildContext context) {
//
//  }
//
//  @override
//  void dispose() {
//    _unsubscribe();
//    super.dispose();
//  }
//
//  void _subscribe() {
//    _subscription = widget.stream.listen((V data) {
//      if (_data != data)
//        setState(() {
//          _data = data;
//          _state = ActiveState();
//        });
//    }, onError: (Object error) {
//      if (_state != error)
//        setState(() {
//          _state = error;
//          _data = null;
//        });
//    }, onDone: () {
//      setState(() {
//        _state = DoneState();
//      });
//    });
//    _data = _data = widget.stream is ValueObservable<V>
//        ? (widget.stream as ValueObservable<V>).value
//        : widget.initialData;
//    _state = WaitingState();
//  }
//
//  void _unsubscribe() {
//    _subscription?.cancel();
//    _subscription = null;
//  }
//
//}