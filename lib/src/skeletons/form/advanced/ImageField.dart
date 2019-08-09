import 'dart:io';

import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/base/Field.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';


class ImageFieldData {
  final String link;
  final File file;

  bool get isMarkForUpload => file != null;
  bool get isMarkForDelete => link != null && file != null;

  bool isDelete;

  ImageFieldData.internal({this.link, this.file, this.isDelete});
  ImageFieldData.link(this.link) : file = null, isDelete = false;
  ImageFieldData.file(this.file) : link = null, isDelete = false;

  ImageFieldData markDelete() {
    return link == null ? null : (
        file == null
            ? _copyWith(isDelete: !isDelete)
            : ImageFieldData.link(this.link)
    );
  }

  ImageFieldData replace(File file) {
    return _copyWith(file: file, isDelete: false);
  }

  ImageFieldData _copyWith({String link, File file, bool isDelete}) {
    return ImageFieldData.internal(
      link: link??this.link,
      file: file??this.file,
      isDelete: isDelete??this.isDelete,
    );
  }

  @override
  String toString() => "ImageData(link: $link, file: $file, isMarkForUpload: $isMarkForUpload, isMarkForDelete: $isMarkForDelete)";
}


abstract class ImageFieldBone extends FieldBone<List<ImageFieldData>> {
  int get maxImages;
}


class ImageFieldSkeleton extends FieldSkeleton<List<ImageFieldData>> implements ImageFieldBone {
  ImageFieldSkeleton({
    List<ImageFieldData> value,
    this.maxImages: 1,
    List<FieldValidator<int>> validators,
  }) : super(
    value: value,
    validators: validators??ImageFieldValidator.base,
  );

  final int maxImages;
}


class ImageFieldShell extends StatefulWidget implements FocusShell {
  final ImageFieldBone bone;
  @override
  final MapFocusBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const ImageFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,

    this.nosy: byPassNoisy, this.decoration: const InputDecoration(),
  }) :
        assert(bone != null),
        assert(decoration != null), super(key: key);

  @override
  _ImageFieldShellState createState() => _ImageFieldShellState();
}

class _ImageFieldShellState extends State<ImageFieldShell> with FocusShellStateMixin {
  FormFieldState<List<ImageFieldData>> _state;

  void _onCreate([ImageFieldData data]) {
    showInputImageDialog(
      context: context,
      outImageFile: (newImage) {
        if (newImage == null)
          return;
        final _value = _state.value.toList();
        if (data == null) {
          _state.didChange(_value..add(ImageFieldData.file(newImage)));
        } else {
          final index = _value.indexOf(data);
          _state.didChange(_value..remove(data)..insert(index, data.replace(newImage)));
        }
      },
    );
  }

  void _onDelete(ImageFieldData data) {
    final value = _state.value.toList();
    final newData = data.markDelete();
    if (newData != null)
      value.insert(value.indexOf(data), newData);
    value.remove(data);
    _state.didChange(value);
  }

  void _onMove(int steps, ImageFieldData data) {
    final value = _state.value.toList();
    final index = value.indexOf(data);
    if (index+steps < 0 || index+steps >= value.length)
      return;
    _state.didChange(value..remove(data)..insert(index+steps, data));
  }

  @override
  Widget build(BuildContext context) {

    return FormField<List<ImageFieldData>>(
      initialValue: widget.bone.value??[],
      onSaved: widget.bone.onSaved,
      validator: (value) => widget.nosy(widget.bone.validator(value))?.text,
      builder: (FormFieldState<List<ImageFieldData>> state) {
        _state = state;
//        if (widget.bone.value != state.value)
//          // ignore: invalid_use_of_protected_member
//          state.setValue(widget.bone.value);
        List<ImageFieldData> _values = state.value;

        return AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListViewPlusChild(
              itemCount: _values.length,
              maxImages: widget.bone.maxImages,
              child: InkWell(
                onTap: _onCreate,
                child: const ImageInputFieldBlank(),
              ),
              builder: (_, index) {
                final data = _values[index];

                final img = ImageFieldDataView(
                  data: data,
                  onCreate: () => _onCreate(data),
                  onDelete: () => _onDelete(data),
                  mover: (steps) => _onMove(steps, data),
                );

                return widget.bone.maxImages < 2 ? img : AspectRatio(
                  aspectRatio: 1,
                  child: img,
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class ImageFieldValidator {
  static get base => [undefined];

  static FieldError undefined(List<ImageFieldData> images) {
    if (images == null || images.length == 0)
      return ImageFieldError.undefined;
    return null;
  }
}

class ImageFieldError {
  static const undefined = FieldError.undefined;
}


void showInputImageDialog({
  @required BuildContext context,
  @required ValueChanged<File> outImageFile,
}) => showDialog(
    context: context,
    builder: (_context) {

      Future<void> pickImage(ImageSource source) async {
        Navigator.pop(_context);
        outImageFile(await ImagePicker.pickImage(source: source, imageQuality: 60));
      }

      return AlertDialog(
        title: Text('Acquisisci una foto'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => pickImage(ImageSource.camera),
            child: Text('Fotocamera'),
          ),
          FlatButton(
            onPressed: () => pickImage(ImageSource.gallery),
            child: Text('Galleria'),
          ),
        ],
      );
    }
);


class ListViewPlusChild extends StatelessWidget {
  final double space;
  final int itemCount, maxImages;
  final IndexedWidgetBuilder builder;
  final Widget child;

  const ListViewPlusChild({Key key,
    this.space: 8.0,
    @required this.itemCount, @required this.maxImages,
    @required this.builder, @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (maxImages < 2) {
      if (itemCount < 1)
        return child;
      else
        return builder(context, 0);
    }

    return ListViewSeparated.builder(
      separator: SizedBox(width: space,),
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount < maxImages ? itemCount+1 : itemCount,
      itemBuilder: (_context, index) {

        if (index < itemCount)
          return builder(_context, index);

        return AspectRatio(
          aspectRatio: 1,
          child: child,
        );
      },
    );
  }
}


class ImageFieldDataView extends StatelessWidget {
  final ImageFieldData data;
  final VoidCallback onCreate;
  final VoidCallback onDelete;
  final ValueChanged<int> mover;

  const ImageFieldDataView({Key key,
    @required this.data, @required this.onCreate, @required this.onDelete, @required this.mover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = data.file != null ? FileImage(data.file) : NetworkImage(data.link);

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      fit: StackFit.expand,
      children: <Widget>[
        InkWell(
          onTap: onCreate,
          child: Image(image: provider, fit: BoxFit.cover,),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 2.0,
            color: data.isDelete ? Colors.red : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
            child: IconButton(
              color: data.isDelete ? Colors.white : null,
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
        if (!data.isDelete) Align( // To Left
          alignment: Alignment.bottomLeft,
          child: Material(
            elevation: 2.0,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
            child: IconButton(
              onPressed: () => mover(-1),
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        if (!data.isDelete) Align( // To Right
          alignment: Alignment.bottomRight,
          child: Material(
            elevation: 2.0,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
            child: IconButton(
              onPressed: () => mover(1),
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }
}


class MoveBackIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class ImageInputFieldBlank extends StatelessWidget {

  const ImageInputFieldBlank({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DottedBorder(
      padding: const EdgeInsets.all(0.0),
      strokeWidth: 2.0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add_a_photo, size: 36),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add_photo_alternate, size: 36),
                ),
              ],
            ),
            Text("Scatta una foto oppure prendila dalla galleria", textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}