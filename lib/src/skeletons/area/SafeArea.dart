import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SafeAreaBone extends Skeleton implements Bone {
  bool _isInSafeArea = true;
  bool get isInSafeArea => _isInSafeArea;

  void updateArea(bool isInSafeArea) {
    _isInSafeArea = isInSafeArea;
  }

  Future<void> workInSafeArea(AsyncCallback worker) async {
    if (_isInSafeArea) {
      try {
        updateArea(false);
        await worker();
        updateArea(true);
      } catch (exc) {
        updateArea(true);
      }
    }
  }

  SafeAreaBone();
  factory SafeAreaBone.of(BuildContext context, [bool allowNull = false]) =>
      BoneProvider.of<SafeAreaBone>(context, allowNull);
}

abstract class SafePeopleBone extends Bone {
  SafeAreaBone _safeArea;
}

mixin SafePeopleSkeleton on Skeleton implements SafePeopleBone {
  SafeAreaBone _safeArea;

  @protected
  Future<void> workInSafeArea(AsyncCallback worker) {
    if (_safeArea == null)
      return worker();
    else
      return _safeArea.workInSafeArea(worker);
  }
}

mixin SafePeopleState<TypeWidget extends StatefulWidget> on State<TypeWidget> {
  SafeAreaBone _safeArea;
  SafePeopleBone _people;
  SafePeopleBone get people;

  bool get isEnableSafeArea;

  @override
  void initState() {
    super.initState();
    _people = people;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isEnableSafeArea) return;
    final newSafeArea = SafeAreaBone.of(context);
    assert(newSafeArea != null);
    if (_safeArea != newSafeArea) {
      _safeArea = newSafeArea;
      _people._safeArea = _safeArea;
    }
  }

  void didUpdateWidget(TypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!isEnableSafeArea) return;
    if (_people != people) {
      _people._safeArea = null;
      _people = people;
      _people._safeArea = _safeArea;
    }
  }

  @override
  void dispose() {
    _people._safeArea = null;
    super.dispose();
  }
}

class SafePeople extends StatefulWidget {
  final SafePeopleBone bone;
  final Widget child;

  const SafePeople({
    Key key,
    @required this.bone,
    @required this.child,
  })  : assert(bone != null),
        assert(child != null),
        super(key: key);

  @override
  _SafePeopleState createState() => _SafePeopleState();
}

class _SafePeopleState extends State<SafePeople> with SafePeopleState<SafePeople> {
  @override
  bool get isEnableSafeArea => true;
  @override
  SafePeopleBone get people => widget.bone;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
