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

Future<T> secureSignError<T>(
  Future<T> future, {
  void adderEmailError(EmailSignError error),
  adderPasswordError(PasswordSignError error),
}) async {
  try {
    return await future;
  } on EmailSignError catch (error) {
    adderEmailError(error);
  } on PasswordSignError catch (error) {
    adderPasswordError(error);
  }
  return null;
}

typedef Future<R> InSignInWithEmailAndPassword<R>(
    {@required String email, @required String password});

abstract class SignBoneBase<U, R> extends Bone {
  Future<U> getCurrentUser();
  Future<R> inSignInWithEmailAndPassword({@required String email, @required String password});
  Future<R> inSignUpWithEmailAndPassword({@required String email, @required String password});
}

abstract class SignSkeletonBase<U, R> extends Skeleton implements SignBoneBase<U, R> {}

mixin SignBlocMixin<U, R> on BlocBase implements SignBoneBase<U, R> {
  SignBoneBase<U, R> get signBone;

  Future<U> getCurrentUser() => signBone.getCurrentUser();

  Future<R> inSignInWithEmailAndPassword({@required String email, @required String password}) {
    return signBone.inSignInWithEmailAndPassword(email: email, password: password);
  }

  Future<R> inSignUpWithEmailAndPassword({@required String email, @required String password}) {
    return signBone.inSignUpWithEmailAndPassword(email: email, password: password);
  }
}

///
/// PROVIDERS
///

typedef Future<void> InSignInGoogle({@required String idToken, @required String accessToken});

abstract class SignProvidersBone<U, R> implements SignBoneBase<U, R> {
  Future<R> inSignInGoogle({@required String idToken, @required String accessToken});
  Future<R> inSignInFacebook({@required String accessToken});
  Future<R> inSignInTwitter({@required String authToken, @required String authTokenSecret});
}

mixin SignProvidersBlocMixin<U, R> on BlocBase implements SignProvidersBone<U, R> {
  SignProvidersBone<U, R> get userBone;
  Future<R> inSignInGoogle({@required String idToken, @required String accessToken}) {
    return userBone.inSignInGoogle(idToken: idToken, accessToken: accessToken);
  }

  Future<R> inSignInFacebook({@required String accessToken}) {
    return userBone.inSignInFacebook(accessToken: accessToken);
  }

  Future<R> inSignInTwitter({@required String authToken, @required String authTokenSecret}) {
    return userBone.inSignInTwitter(authToken: authToken, authTokenSecret: authTokenSecret);
  }
}
