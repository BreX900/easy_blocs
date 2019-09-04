import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/skeletons/ModelBase.dart';
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/button/Button.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/EmailField.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/RepeatPasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/base/ButtonField.dart';
import 'package:easy_blocs/src/user/User.dart';
import 'package:easy_blocs/src/utility.dart';
import 'package:flutter/foundation.dart';

abstract class SignUpBone extends Bone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  RepeatPasswordFieldBone get repeatPasswordFieldBone;
  ButtonFieldBone get buttonFieldBone;
}

class SignUpSkeleton<U extends ModelBase> extends Skeleton implements SignUpBone {
  AsyncValueSetter<U> onResult;
  UserBoneBase<U> userBone;

  SignUpSkeleton([this.userBone]) {
    _buttonFieldSkeleton.onSubmit = submit;
    final passwordValidator = RepeatPasswordFieldValidator();
    _passwordFieldSkeleton.validators.add(passwordValidator.password);
    _repeatPasswordFieldSkeleton.validators.add(passwordValidator.repeatPassword);
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

  final RepeatPasswordFieldSkeleton _repeatPasswordFieldSkeleton = RepeatPasswordFieldSkeleton();
  RepeatPasswordFieldBone get repeatPasswordFieldBone => _repeatPasswordFieldSkeleton;

  final ButtonFieldSkeleton _buttonFieldSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get buttonFieldBone => _buttonFieldSkeleton;

  Future<ButtonState> submit() async {
    assert(userBone != null);
    final res = await secureSignError(
      userBone.inSignUpWithEmailAndPassword(
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

mixin SingUpBlocMixer on BlocBase implements SignUpBone {
  SignUpBone get signUpBone;

  EmailFieldBone get emailFieldBone => signUpBone.emailFieldBone;
  PasswordFieldBone get passwordFieldBone => signUpBone.passwordFieldBone;
  RepeatPasswordFieldBone get repeatPasswordFieldBone => signUpBone.repeatPasswordFieldBone;
  ButtonFieldBone get buttonFieldBone => signUpBone.buttonFieldBone;
}