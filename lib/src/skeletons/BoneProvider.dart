
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:flutter/widgets.dart';


class BoneProvider<BoneType extends Bone> extends InheritedWidget {
  final BoneType bone;

  BoneProvider({
    Key key,
    @required this.bone,
    @required Widget child,
  })
      : assert(bone != null),
        assert(child != null),
        super(key: key, child: child);

  BoneProvider.tree(this.bone) : super();

  static BoneType of<BoneType extends Bone>(BuildContext context, [allowNull = true]) {

    Type typeOf<T>() => T;

    final bone = (
        context.ancestorInheritedElementForWidgetOfExactType(
            typeOf<BoneProvider<BoneType>>()
        )?.widget as BoneProvider<BoneType>)?.bone;

    assert(allowNull || bone != null, "The $BoneType must not null");

    return bone;
  }

  @override
  bool updateShouldNotify(BoneProvider old) {
    return bone != old.bone;
  }

  BoneProvider<BoneType> copyWith(Widget child) {
    return BoneProvider<BoneType>(
      key: key,
      bone: bone,
      child: child,
    );
  }
}


