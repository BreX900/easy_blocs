import 'package:easy_blocs/src/skeletons/BlocProvider.dart';
import 'package:easy_blocs/src/skeletons/Skeleton.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/EmailField.dart';
import 'package:easy_blocs/src/skeletons/form/advanced/PasswordField.dart';
import 'package:easy_blocs/src/skeletons/form/base/ButtonField.dart';
import 'package:easy_blocs/src/user/Sign.dart';
import 'package:flutter/foundation.dart';

abstract class SignInBone extends Bone {
  EmailFieldBone get emailFieldBone;
  PasswordFieldBone get passwordFieldBone;
  ButtonFieldBone get buttonFieldBone;
}

class SignInSkeleton<R> extends Skeleton implements SignInBone {
  AsyncValueSetter<R> onResult;
  InSignInWithEmailAndPassword<R> signer;

  SignInSkeleton({@required this.signer}) {
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

  Future<bool> submit() async {
    assert(signer != null);
    final res = await secureSignError(
      signer(
        email: _emailFieldSkeleton.value,
        password: _passwordFieldSkeleton.value,
      ),
      adderEmailError: _emailFieldSkeleton.inSignError,
      adderPasswordError: _passwordFieldSkeleton.inSignError,
    );
    await onResult(res);
    return res == null ? true : false;
  }
}

mixin SingInBlocMixer on BlocBase implements SignInBone {
  SignInBone get signInBone;

  EmailFieldBone get emailFieldBone => signInBone.emailFieldBone;
  PasswordFieldBone get passwordFieldBone => signInBone.passwordFieldBone;
  ButtonFieldBone get buttonFieldBone => signInBone.buttonFieldBone;
}
