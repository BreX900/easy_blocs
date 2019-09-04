import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/skeletons/ModelBase.dart';
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/button/Button.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/EmailField.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/base/ButtonField.dart';
import 'package:easy_blocs/src/user/User.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/foundation.dart';

abstract class SignInBone extends Bone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  ButtonFieldBone get buttonFieldBone;
}

class SignInSkeleton<U extends ModelBase> extends Skeleton implements SignInBone {
  AsyncValueSetter<U> onResult;
  UserBoneBase<U> userBone;

  SignInSkeleton([this.userBone]) {
    _buttonFieldSkeleton.onSubmit = submit;
  }

  @override
  void dispose() {
    _emailFieldSkeleton.dispose();
    _passwordFieldSkeleton.dispose();
    _buttonFieldSkeleton.dispose();
    super.dispose();
  }

  final EmailFieldSkeleton _emailFieldSkeleton = EmailFieldSkeleton();
  EmailFieldBone get emailFieldBone => _emailFieldSkeleton;

  final PasswordFieldSkeleton _passwordFieldSkeleton = PasswordFieldSkeleton();
  PasswordFieldBone get passwordFieldBone => _passwordFieldSkeleton;

  final ButtonFieldSkeleton _buttonFieldSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get buttonFieldBone => _buttonFieldSkeleton;

  Future<ButtonState> submit() async {
    assert(userBone != null);
    final res = await secureSignError(
      userBone.inSignInWithEmailAndPassword(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      ),
      adderEmailError: _emailFieldSkeleton.inSignError,
      adderPasswordError: _passwordFieldSkeleton.inSignError,
    );
    if (!res) return ButtonState.enabled;
    await onResult(await userBone.waitRegistrationLv(0));
    return ButtonState.disabled;
  }
}

mixin SingInBlocMixer on BlocBase implements SignInBone {
  SignInBone get signInBone;

  EmailFieldBone get emailFieldBone => signInBone.emailFieldBone;
  PasswordFieldBone get passwordFieldBone => signInBone.passwordFieldBone;
  ButtonFieldBone get buttonFieldBone => signInBone.buttonFieldBone;
}
