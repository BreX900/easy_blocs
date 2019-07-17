import 'package:easy_blocs/src/skeletons/Skeleton.dart';


abstract class ButtonBone extends Bone {
  Stream<bool> get outButtonSheet;

  Future<void> onPressed();
}