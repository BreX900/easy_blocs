import 'package:flutter/widgets.dart';


abstract class Manager {

}



class ManagerProvider<ManagerType extends Manager> extends InheritedWidget {
  final ManagerType manager;

  ManagerProvider({
    Key key,
    @required this.manager,
    @required Widget child,
  })
      : assert(manager != null),
        assert(child != null),
        super(key: key, child: child);

  ManagerProvider.tree(this.manager) : super();

  static ManagerType of<ManagerType extends Manager>(BuildContext context) {

    Type typeOf<T>() => T;

    return (
        context.ancestorInheritedElementForWidgetOfExactType(
            typeOf<ManagerProvider<ManagerType>>()
        )?.widget as ManagerProvider<ManagerType>)?.manager;
  }

  @override
  bool updateShouldNotify(ManagerProvider old) {
    return false;
  }

  ManagerProvider<ManagerType> copyWith(Widget child) {
    return ManagerProvider<ManagerType>(
      key: key,
      manager: manager,
      child: child,
    );
  }
}

