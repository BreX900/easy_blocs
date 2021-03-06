//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:easy_blocs/src/skeletons/puzzle/Puzzle.dart';
//import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//class TextPieceSheet extends SheetPieceEvent<String> {
//  const TextPieceSheet({
//    ArrisEvent event, String value, PieceError error,
//  }) : super(
//    event: event, value: value, error: error,
//  );
//
//  TextPieceSheet copyWith({ArrisEvent event, String value, PieceError error}) {
//    return TextPieceSheet(
//      event: event??this.event,
//      value: value??this.value,
//      error: error,
//    );
//  }
//}
//
//
//class TextPieceSkeleton extends PieceSkeleton<TextPieceSheet, String> {
//  TextPieceSkeleton({
//    String seed,
//    List<PieceValidator<String>> validators,
//  }) : super(seed: seed, validators: validators);
//}
//
//
//class TextPiece extends StatefulWidget implements Piece<TextPieceSheet, String>, FocusShell {
//  final PieceBone<TextPieceSheet, String> bone;
//  final ValueChanged<PieceEvent> inEvent;
//  final PieceErrorTranslator translator;
//  final InputDecoration decoration;
//
//  final MapFocusBone mapFocusBone;
//  final FocusNode focusNode;
//
//  const TextPiece({Key key,
//    @required this.bone,
//    this.translator,
//    this.decoration: const InputDecoration(),
//
//    this.mapFocusBone, this.focusNode,
//  }) : assert(bone != null), super(key: key);
//
//  @override
//  _TextPieceState createState() => _TextPieceState();
//}
//
//class _TextPieceState extends State<TextPiece>
//    with PieceStateMixin<TextPiece, TextPieceSheet, String>, FocusShellStateMixin {
//
//  TextEditingController _controller;
//  TextPieceSheet _sheet;
//
//  @override
//  void initState() {
//    super.initState();
//    _sheet = widget.bone.outSheet is ValueObservable<TextPieceSheet>
//        ? (widget.bone.outSheet as ValueObservable<TextPieceSheet>).value
//        : const TextPieceSheet(event: const EnableArrisEvent());
//    _controller = TextEditingController(text: _sheet.value);
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  void sheetListener(sheet) {
//    if (sheet is TextPieceSheet) {
//      if (_sheet.value != sheet.value) {
//        _sheet = sheet;
//        if (_sheet.value != _controller.text)
//          _controller.text = _sheet.value;
//      }
//      if (_sheet.event != sheet.event || _sheet.error != sheet.error) {
//        setState(() => _sheet = sheet);
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return TextField(
//      controller: _controller,
//      enabled: _sheet.event is EnableArrisEvent,
//      onChanged: inValue,
//      onSubmitted: (_) => nextFocus(),
//      decoration: widget.decoration.copyWith(
//        errorText: widget.translator(_sheet.error),
//      ),
//
//      focusNode: focusNode,
//    );
//  }
//
//
//}
//
//Widget test() {
//  final TextPieceSkeleton skeleton = TextPieceSkeleton();
//
//  return ObservableBuilder((_, values, state) {
//    return TextPiece(
//      bone: skeleton,
//    );
//  }, stream: skeleton.outTmpValue,);
//}