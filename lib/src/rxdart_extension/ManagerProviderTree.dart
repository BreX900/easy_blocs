import 'package:easy_blocs/src/rxdart_extension/ManagerProvider.dart';
import 'package:flutter/widgets.dart';


class ManagerProviderTree extends StatelessWidget {

  final List<ManagerProvider> managerProviders;

  final Widget child;

  const ManagerProviderTree({
    Key key,
    @required this.managerProviders,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tree = child;
    for (final blocProvider in managerProviders.reversed) {
      tree = blocProvider.copyWith(tree);
    }
    return tree;
  }
}