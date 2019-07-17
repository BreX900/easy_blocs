import 'package:easy_blocs/src/skeletons/BoneProvider.dart';
import 'package:flutter/widgets.dart';


class BoneProviderTree extends StatelessWidget {

  final List<BoneProvider> boneProviders;

  final Widget child;

  const BoneProviderTree({
    Key key,
    @required this.boneProviders,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tree = child;
    for (final blocProvider in boneProviders.reversed) {
      tree = blocProvider.copyWith(tree);
    }
    return tree;
  }
}