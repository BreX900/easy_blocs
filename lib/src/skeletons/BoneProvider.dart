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

  static BoneType of<BoneType extends Bone>(BuildContext context) {

    Type typeOf<T>() => T;

    return (
        context.ancestorInheritedElementForWidgetOfExactType(
            typeOf<BoneProvider<BoneType>>()
        )?.widget as BoneProvider<BoneType>)?.bone;
  }

  @override
  bool updateShouldNotify(BoneProvider old) {
    return false;
  }

  BoneProvider<BoneType> copyWith(Widget child) {
    return BoneProvider<BoneType>(
      key: key,
      bone: bone,
      child: child,
    );
  }
}


/*typedef C Creator<C>(BuildContext context);

typedef C CreatorByValue<C, V>(BuildContext context, V value);


class ManagerProviderBuilder<M extends Manager> extends StatefulWidget {
  final Creator<M> builder;

  final CreatorByValue<Widget, M> creator;

  const ManagerProviderBuilder({Key key, this.builder, this.creator}) : super(key: key);

  @override
  _ManagerProviderBuilderState<M> createState() => _ManagerProviderBuilderState();
}

class _ManagerProviderBuilderState<M extends Manager> extends State<ManagerProviderBuilder<M>> {
  M manager;

  @override
  void initState() {
    super.initState();
    manager = widget.builder(context);
  }

  @override
  Widget build(BuildContext context) {
    return ManagerProvider(
      manager: manager,
      child: widget.creator(context, manager),
    );
  }
}*/