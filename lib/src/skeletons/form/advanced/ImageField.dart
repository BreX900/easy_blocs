import 'dart:collection';
import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/skeletons/AutomaticFocus.dart';
import 'package:easy_blocs/src/skeletons/form/Form.dart';
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
  ImageFieldData.link(this.link)
      : file = null,
        isDelete = false;
  ImageFieldData.file(this.file)
      : link = null,
        isDelete = false;

  ImageFieldData markDelete() {
    return link == null
        ? null
        : (file == null ? _copyWith(isDelete: !isDelete) : ImageFieldData.link(this.link));
  }

  ImageFieldData replace(File file) {
    return _copyWith(file: file, isDelete: false);
  }

  ImageFieldData _copyWith({String link, File file, bool isDelete}) {
    return ImageFieldData.internal(
      link: link ?? this.link,
      file: file ?? this.file,
      isDelete: isDelete ?? this.isDelete,
    );
  }

  @override
  String toString() =>
      "ImageData(link: $link, file: $file, isMarkForUpload: $isMarkForUpload, isMarkForDelete: $isMarkForDelete)";
}

abstract class ImageFieldBone extends FieldBone<UnmodifiableListView<ImageFieldData>> {
  int get maxImages;
  Stream<FieldError> get outError;

  void create(File newImage);
  void replace(ImageFieldData data, File newImage);
  void delete(ImageFieldData data);
  void move(ImageFieldData data, int steps);
}

class ImageFieldSkeleton extends FieldSkeleton<UnmodifiableListView<ImageFieldData>>
    implements ImageFieldBone {
  ImageFieldSkeleton({
    List<ImageFieldData> seed,
    this.maxImages: 1,
    List<FieldValidator<int>> validators,
  }) : super(
          seed: seed ?? UnmodifiableListView(const []),
          validators: validators ?? ImageFieldValidator.base,
        );

  final int maxImages;

  @override // TODO: Add FieldState
  void inFieldState(FieldState state) {}

  Future<void> create(File newImage) async {
    final newTmpValue = tmpValue.toList()..add(ImageFieldData.file(newImage));
    inTmpValue(UnmodifiableListView(newTmpValue));
  }

  Future<void> replace(ImageFieldData data, File newImage) async {
    final index = tmpValue.indexOf(data);
    final newTmpValue = tmpValue.toList()
      ..removeAt(index)
      ..insert(index, data.replace(newImage));
    inTmpValue(UnmodifiableListView(newTmpValue));
  }

  Future<void> delete(ImageFieldData data) async {
    final newTmpValue = tmpValue.toList()..remove(data);
    final index = newTmpValue.indexOf(data);
    final newData = data.markDelete();
    if (newData != null) newTmpValue.insert(index, newData);
    inTmpValue(UnmodifiableListView(newTmpValue));
  }

  Future<void> move(ImageFieldData data, int steps) async {
    final index = tmpValue.indexOf(data);
    if (index + steps < 0 || index + steps >= tmpValue.length) return;
    final newTmpValue = tmpValue.toList()
      ..remove(data)
      ..insert(index + steps, data);
    inTmpValue(UnmodifiableListView(newTmpValue));
  }
}

class ImageFieldShell extends StatefulWidget implements FieldShell, FocusShell {
  final ImageFieldBone bone;
  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const ImageFieldShell({
    Key key,
    @required this.bone,
    this.mapFocusBone,
    this.focusNode,
    this.nosy: basicNoisy,
    this.decoration: const InputDecoration(),
  })  : assert(bone != null),
        assert(decoration != null),
        super(key: key);

  @override
  _ImageFieldShellState createState() => _ImageFieldShellState();
}

class _ImageFieldShellState extends FieldState<ImageFieldShell>
    with FocusShellStateMixin {
  void _onCreate([ImageFieldData data]) {
    showInputImageDialog(
      context: context,
      outImageFile: (newImage) {
        if (newImage == null) return;
        if (data == null) {
          widget.bone.create(newImage);
        } else {
          widget.bone.replace(data, newImage);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ObservableListBuilder<ImageFieldData>(
            stream: widget.bone.outTmpValue,
            builder: (_, itemBuilder, state) {
              return ListViewPlusChild(
                itemCount: state.data?.length ?? 0,
                maxImages: widget.bone.maxImages,
                child: InkWell(
                  onTap: _onCreate,
                  child: const ImageInputFieldBlank(),
                ),
                builder: itemBuilder,
              );
            },
            itemBuilder: (_, data, info) {
              final img = ImageFieldDataView(
                data: data,
                onCreate: () => _onCreate(data),
                onDelete: () => widget.bone.delete(data),
                mover: (steps) => widget.bone.move(data, steps),
              );
              return widget.bone.maxImages < 2
                  ? img
                  : AspectRatio(
                      aspectRatio: 1,
                      child: img,
                    );
            },
          ),
        ),
        ObservableBuilder(
          stream: widget.bone.outError,
          builder: (_, error, state) {
            return error == null
                ? const SizedBox()
                : Text(
                    widget.nosy(error)?.text,
                    style: Theme.of(context).inputDecorationTheme.errorStyle,
                  );
          },
        ),
      ],
    );
  }
}

class ImageFieldValidator {
  static List<FieldValidator<List<ImageFieldData>>> get base => [undefined];

  static Future<FieldError> undefined(List<ImageFieldData> images) async {
    if (images == null || images.length == 0) return ImageFieldError.undefined;
    return null;
  }
}

class ImageFieldError {
  static const undefined = FieldError.$undefined;
}

void showInputImageDialog({
  @required BuildContext context,
  @required ValueChanged<File> outImageFile,
}) =>
    showDialog(
        context: context,
        builder: (_context) {
          Future<void> pickImage(ImageSource source) async {
            Navigator.pop(_context);
            outImageFile(await ImagePicker.pickImage(source: source));
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
        });

class ListViewPlusChild extends StatelessWidget {
  final double space;
  final int itemCount, maxImages;
  final IndexedWidgetBuilder builder;
  final Widget child;

  const ListViewPlusChild({
    Key key,
    this.space: 8.0,
    @required this.itemCount,
    @required this.maxImages,
    @required this.builder,
    @required this.child,
  })  : assert(itemCount != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount < 1)
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: space),
        child: child,
      );

    if (maxImages < 2)
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: space),
        child: builder(context, 0),
      );

    return ListViewSeparated.builder(
      separator: SizedBox(
        width: space,
      ),
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount < maxImages ? itemCount + 1 : itemCount,
      itemBuilder: (_context, index) {
        if (index < itemCount) return builder(_context, index);

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

  const ImageFieldDataView({
    Key key,
    @required this.data,
    @required this.onCreate,
    @required this.onDelete,
    @required this.mover,
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
          child: Image(
            image: provider,
            fit: BoxFit.cover,
          ),
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
        if (!data.isDelete)
          Align(
            // To Left
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
        if (!data.isDelete)
          Align(
            // To Right
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
            Text(
              "Scatta una foto oppure prendila dalla galleria",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
