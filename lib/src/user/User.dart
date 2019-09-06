import 'package:easy_blocs/easy_blocs.dart';

abstract class UserBoneBase<U extends ModelBase> extends Bone {
  Stream<U> get outUser;
  U get user;

  Stream<int> get outRegistrationLv;
  int get registrationLv;

  Future<U> getUserByRegistrationLv(int registrationLv);

  Future<void> logout();
}

abstract class UserSkeletonBase<U extends ModelBase> extends Skeleton implements UserBoneBase<U> {}

mixin UserBlocMixin<U extends ModelBase> on BlocBase implements UserBoneBase<U> {
  UserBoneBase<U> get userBone;

  Stream<U> get outUser => userBone.outUser;
  U get user => userBone.user;

  Stream<int> get outRegistrationLv => userBone.outRegistrationLv;
  int get registrationLv => userBone.registrationLv;

  Future<U> getUserByRegistrationLv(int registrationLv) =>
      userBone.getUserByRegistrationLv(registrationLv);

  Future<void> logout() => userBone.logout();
}
