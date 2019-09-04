import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum EmailSignError {
  /// Delete error in stream [null]
  /// The email address is badly formatted.
  INVALID,

  /// [ERROR_INVALID_EMAIL]
  /// There is no user record corresponding to this identifier. The user may have been deleted.
  USER_NOT_FOUND,

  /// [ERROR_USER_NOT_FOUND]
  /// The user account has been disabled by an administrator.
  USER_DISABLE,

  /// [ERROR_USER_DISABLED]
  /// Current email already use
  ALREADY_IN_USE,

  /// [ERROR_EMAIL_ALREADY_IN_USE]
}
enum PasswordSignError {
  /// Delete error in stream [null]
  /// Must have at least 8 characters, a number, a symbol, a lowercase letter and a capital letter
  INVALID,

  /// Wrong password
  WRONG,

  /// It is not the same as the previous password
  NOT_SAME,
}

Future<bool> secureSignError<T>(
    Future<T> future, {
      void adderEmailError(EmailSignError error),
      adderPasswordError(PasswordSignError error),
    }) async {
  try {
    await future;
    return true;
  } on EmailSignError catch (error) {
    adderEmailError(error);
  } on PasswordSignError catch (error) {
    adderPasswordError(error);
  }
  return false;
}

abstract class UserBoneBase<U extends ModelBase> extends Bone {
  Future<void> inSignInWithEmailAndPassword({@required String email, @required String password});
  Future<void> inSignUpWithEmailAndPassword({@required String email, @required String password});
  Future<U> waitRegistrationLv(int registrationLv);
}

abstract class UserSkeletonBase<U extends ModelBase> extends Skeleton implements UserBoneBase<U> {}

mixin UserBlocMixin<U extends ModelBase> on BlocBase {
  UserBoneBase<U> get userBone;

  Future<void> inSignInWithEmailAndPassword({@required String email, @required String password}) {
    return userBone.inSignInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> inSignUpWithEmailAndPassword({@required String email, @required String password}) {
    return userBone.inSignUpWithEmailAndPassword(email: email, password: password);
  }

  Future<U> waitRegistrationLv(int registrationLv) => userBone.waitRegistrationLv(registrationLv);
}

typedef Future<void> InSignInGoogle({@required String idToken, @required String accessToken});

abstract class SignProvidersBone<U extends ModelBase> implements UserBoneBase<U> {
  Future<void> inSignInGoogle({@required String idToken, @required String accessToken});
  Future<void> inSignInFacebook({@required String accessToken});
  Future<void> inSignInTwitter({@required String authToken, @required String authTokenSecret});
}

mixin SignProvidersBlocMixin<U extends ModelBase> on BlocBase implements SignProvidersBone<U> {
  SignProvidersBone<U> get userBone;
  Future<void> inSignInGoogle({@required String idToken, @required String accessToken}) {
    return userBone.inSignInGoogle(idToken: idToken, accessToken: accessToken);
  }

  Future<void> inSignInFacebook({@required String accessToken}) {
    return userBone.inSignInFacebook(accessToken: accessToken);
  }

  Future<void> inSignInTwitter({@required String authToken, @required String authTokenSecret}) {
    return userBone.inSignInTwitter(authToken: authToken, authTokenSecret: authTokenSecret);
  }
}
