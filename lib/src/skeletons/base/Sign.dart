import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


abstract class UserSkeletonBase extends Skeleton implements UserBoneBase {

}

abstract class UserBoneBase extends Bone {
  Future<void> inSignInWithEmailAndPassword({@required String email, @required String password});
}



class LoginFormSkeleton extends Skeleton implements LoginFormBone {
  UserBoneBase userBone;

  LoginFormSkeleton([this.userBone]) {
    _buttonSkeleton.onSubmit = submit;
  }

  @override
  void dispose() {
    _emailFieldSkeleton.dispose();
    _passwordFieldSkeleton.dispose();
    _buttonSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final EmailFieldSkeleton _emailFieldSkeleton = EmailFieldSkeleton();
  EmailFieldBone get emailFieldBone => _emailFieldSkeleton;

  final PasswordFieldSkeleton _passwordFieldSkeleton = PasswordFieldSkeleton();
  PasswordFieldBone get passwordFieldBone => _passwordFieldSkeleton;

  final ButtonSkeleton _buttonSkeleton = ButtonSkeleton();
  ButtonBone get buttonFieldBone => _buttonSkeleton;

  PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  Future<bool> submit() async {
    assert(userBone != null);
    try {
      await userBone.inSignInWithEmailAndPassword(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      );
      _eventController.add(true);
    } catch(exc) {
      _eventController.add(exc);
      return true;
    }
    return false;
  }
}


abstract class LoginFormBone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  ButtonBone get buttonFieldBone;
  Stream get outEvent;
}


