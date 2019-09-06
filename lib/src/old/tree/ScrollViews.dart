//import 'dart:collection';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//
//class TreeScrollView extends StatefulWidget {
//  final List<StatelessBranch> branches;
//
//  const TreeScrollView({Key key, @required this.branches,
//  }) : assert(branches != null), super(key: key);
//
//  @override
//  _TreeScrollViewState createState() => _TreeScrollViewState();
//}
//
//class _TreeScrollViewState extends State<TreeScrollView> {
//  List<StateBranch> _states;
//
//  @override
//  void initState() {
//    super.initState();
//    _initTree();
//  }
//
//  @override
//  void didUpdateWidget(TreeScrollView oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.branches != widget.branches) {
//      _disposeTree();
//      _initTree();
//    }
//  }
//
//  @override
//  void dispose() {
//    _disposeTree();
//    super.dispose();
//  }
//
//  void _initTree() {
//    _states = [];
//    widget.branches.map((branch) {
//      if (branch is StatefulBranch) {
//        final state = branch.createState();
//        state._tree = this;
//        _states.add(state);
//      }
//    }).toList();
//  }
//  void _disposeTree() {
//    _states.forEach((state) => state.dispose());
//    _states = null;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final slivers = <Widget>[];
//
//    widget.branches.forEach((branch) => slivers.addAll(branch.buildBranch(context)));
//
//    return CustomScrollView(
//      slivers: slivers,
//    );
//  }
//}
//
//
//abstract class StatelessBranch {
//  const StatelessBranch();
//
//
//
////  @mustCallSuper
////  void didChangeDependencies(BuildContext context) {}
//
//
//
//  List<Widget> buildBranch(BuildContext context);
//}
//
//
//abstract class StatefulBranch extends StatelessBranch {
//  StateBranch<StatefulBranch> createState();
//}
//
//abstract class StateBranch<B extends StatefulBranch> {
//  _TreeScrollViewState _tree;
//
//  B _branch;
//  B get branch => _branch;
//
//  BuildContext get context => _tree.context;
//// ignore: invalid_use_of_protected_member
//  void setState(Function function) => _tree.setState(function);
//
//  @mustCallSuper
//  void initState() {}
//
//  @mustCallSuper
//  void dispose() {}
//}
//
//
//mixin BranchMixin on Widget implements StatelessBranch {
//  @override
//  List<Widget> buildBranch(BuildContext context) {
//    return [this];
//  }
//}
