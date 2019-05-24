import 'dart:async';

import 'package:flutter/widgets.dart';


/// It allows a dynamic loading of the elements a scrollView per page.
/// We recommend a value of items equal to the number of items visible
/// on the screen * 2.5
///
/// Optionally it allows an automatic view update
/// via the view constructor stream without the use of [PageConnector.nextPage]
class PageConnector {
  ScrollController _controller;
  int _currentPage;
  bool _isPerform = false;
  final ValueChanged<int> onPage;

  /// For BlocPattern. New page notifier
  Stream _stream;
  StreamSubscription _streamSubscription;

  PageConnector({
    int initialValue: 1, bool loadFirstPage: false,
    @required this.onPage,
    ScrollController controller, Stream stream,
  }) : _currentPage = initialValue, assert(onPage != null)
  {
    if (controller != null)
      this.controller = controller;
    if (stream != null)
      this.stream = stream;
    if (loadFirstPage)
      onPage(initialValue);
  }

  /// The page number to which the user has arrived
  int get currentPage => _currentPage;
  /// The Request for new Page is perform?
  bool get isPerform => _isPerform;

  double get currentPosition => _controller.position.pixels;
  double get maxPosition => _controller.position.maxScrollExtent;

  /// The user scrolling controller
  set controller(ScrollController controller) {
    assert(controller != null);
    _controller?.removeListener(_listener);
    _controller = controller;
    _controller.addListener(_listener);
  }

  /// Listen to user scrolling
  void _listener() {
    if (currentPosition > maxPosition-(maxPosition/(2*_currentPage)) && !_isPerform) {
      _isPerform = true;
      onPage(++_currentPage);
    }
  }

  /// Free up resources
  void dispose() {
    _controller?.removeListener(_listener);
    _streamSubscription?.cancel();
  }

  ///Enable the loading of the next page if it has already occurred
  void nextPage() {
    _isPerform = false;
  }

  /// For BlocPattern. New page notifier
  set stream(Stream stream) {
    assert(stream != null);
    _streamSubscription?.cancel();
    _stream = stream;
    _streamSubscription = _stream.listen((_) => nextPage());
  }
}