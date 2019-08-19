import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


enum EmailSignError {/// Delete error in stream [null]
  /// The email address is badly formatted.
  INVALID, /// [ERROR_INVALID_EMAIL]
  /// There is no user record corresponding to this identifier. The user may have been deleted.
  USER_NOT_FOUND, /// [ERROR_USER_NOT_FOUND]
  /// The user account has been disabled by an administrator.
  USER_DISABLE, /// [ERROR_USER_DISABLED]
  /// Current email already use
  ALREADY_IN_USE, /// [ERROR_EMAIL_ALREADY_IN_USE]
}
enum PasswordSignError {/// Delete error in stream [null]
  /// Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter
  INVALID,
  /// Wrong password
  WRONG,
  /// It is not the same as the previous password
  NOT_SAME,
}


Future<bool> secureSignError<T>(Future future, {
  void adderEmailError(EmailSignError error), adderPasswordError(PasswordSignError error),
}) async {
  try {
    await future;
    return true;
  } on EmailSignError catch(error) {
    adderEmailError(error);
  } on PasswordSignError catch(error) {
    adderPasswordError(error);
  }
  return false;
}


abstract class UserSkeletonBase<U extends ModelBase> extends Skeleton implements UserBoneBase<U> {

}

abstract class UserBoneBase<U extends ModelBase> extends Bone {
  Stream<U> get outUser;

  Future<void> inSignInWithEmailAndPassword({@required String email, @required String password});
  Future<void> inSignUpWithEmailAndPassword({@required String email, @required String password});
  Future<U> waitRegistrationLv(int registrationLv);
}


abstract class SignInBone extends Bone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  ButtonFieldBone get buttonFieldBone;
}

class SignInSkeleton<U extends ModelBase> extends Skeleton implements SignInBone {
  ValueChanged onResult;
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
    try {
      await userBone.inSignInWithEmailAndPassword(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      );
      secureSignError(userBone.inSignInWithEmailAndPassword(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      ),
        adderEmailError: _emailFieldSkeleton.inSignError,
        adderPasswordError: _passwordFieldSkeleton.inSignError,
      );
      onResult(CompletedEvent([await userBone.waitRegistrationLv(0)]));
    } catch(exc) {
      switch (exc) {

      }
      onResult(exc);
      return ButtonState.enabled;
    }
    return ButtonState.disabled;
  }
}

mixin SingInBlocMixer on BlocBase implements SignInBone {
  SignInBone get signInBone;

  EmailFieldBone get emailFieldBone => signInBone.emailFieldBone;
  PasswordFieldBone get passwordFieldBone => signInBone.passwordFieldBone;
  ButtonFieldBone get buttonFieldBone => signInBone.buttonFieldBone;
}



abstract class SignUpBone extends Bone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  RepeatPasswordFieldBone get repeatPasswordFieldBone;
  ButtonFieldBone get buttonFieldBone;
}

class SignUpSkeleton<U extends ModelBase> extends Skeleton implements SignUpBone {
  ValueChanged onResult;
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
    try {
      await userBone.inSignUpWithEmailAndPassword(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      );
      onResult(CompletedEvent([await userBone.waitRegistrationLv(0)]));
    } catch(exc) {
      onResult(exc);
      return ButtonState.enabled;
    }
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