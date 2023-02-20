// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../base/generated/locale/locale_keys.g.dart';
import '../../../../configs/configs.dart';
import '../../../../configs/logger.dart';
import 'login_type.dart';
import 'models/auth_user.dart';
import 'user_not_found_exception.dart';

part '../../../../base/generated/lib/extensions/providers/firebase/auth/provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthProvider firebaseAuth(FirebaseAuthRef ref) =>
    FirebaseAuthProvider();

class FirebaseAuthProvider {
  Future<AuthUser> loginWithSocialAuth(LoginType loginType) async {
    Log.log.i('Login with ${loginType.toString()} clicked');
    switch (loginType) {
      case LoginType.facebook:
        return await _signInWithFacebook();
      case LoginType.google:
        return await _signInWithGoogle();
      case LoginType.apple:
        return await _signInWithApple();
      default:
        Log.log.w('Invalid social login type');
        throw Exception('Invalid social login type');
    }
  }

  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      return _onAuthSuccess(LoginType.email, user);
    } on FirebaseAuthException catch (ex) {
      throw _onAuthFailed(LoginType.email, ex);
    } catch (ex) {
      throw _onAuthFailed(LoginType.email, ex);
    }
  }

  Future<AuthUser> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      await user.updateDisplayName(name);
      return _onAuthSuccess(LoginType.email, user);
    } on FirebaseAuthException catch (ex) {
      throw _onAuthFailed(LoginType.email, ex);
    } catch (ex) {
      throw _onAuthFailed(LoginType.email, ex);
    }
  }

  Future<AuthUser> autoSignUserIn() async {
    try {
      FirebaseAuth.instance.currentUser?.reload();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return _onAuthSuccess(LoginType.auto, user);
      } else {
        throw UserNotFoundExecption('User not found');
      }
    } catch (ex) {
      throw _onAuthFailed(LoginType.auto, ex);
    }
  }

  Future<bool> isEmailVerified() async {
    FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;
    if (user?.emailVerified ?? false) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> resetPassword(BuildContext context, WidgetRef ref, String email,
      {required Function resetSuccess, required Function resetFailed}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      resetSuccess();
    } on FirebaseAuthException catch (exception) {
      Log.log.w(exception.toString());
      _handleFirebaseException(exception);
      resetFailed();
    }
  }

  void signOutFromAll(OnSignOut onSignOut) {
    FirebaseAuth.instance.signOut().then((it) {
      onSignOut();
    });
    Log.log.i('User sign out success');
  }

  Future<void> updateUserInfo(
      BuildContext context, WidgetRef ref, LoginType loginType,
      {required OnUserProfileUpdateSuccess success,
      required OnUserProfileUpdateFailed failed,
      String? name,
      String? password,
      File? photo}) async {
    try {
      Log.log.i('Updating user info');

      User user = FirebaseAuth.instance.currentUser!..reload();

      if (password != null && password.isNotEmpty) {
        await user.updatePassword(password);
        Log.log.i('Password saved successful');
      }

      if (photo != null && photo.path != '') {
        String photoUrl =
            await _addImageToStorage('user/profile/${user.uid}.jpg', photo);
        await user.updatePhotoURL(photoUrl);
        Log.log.i('Photo saved successful');
      }

      if (name != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
        Log.log.i('Name saved successful');
      }
      user = FirebaseAuth.instance.currentUser!
        ..reload().then((value) async {
          AuthUser authUser = await _getAuthUser(loginType, user);
          success(authUser);
        });
    } on FirebaseException catch (ex) {
      Log.log.w(ex);
      _handleFirebaseException(ex);
      failed(ex);
    } catch (ex) {
      Log.log.w(ex);
      _handleGenericException(ex);
      failed(ex);
    }
  }

  Future<AuthUser> _signInWithGoogle() async {
    LoginType loginType = LoginType.google;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      return _onAuthSuccess(loginType, user!);
    } catch (ex) {
      throw _onAuthFailed(loginType, ex);
    }
  }

  Future<AuthUser> _signInWithFacebook() async {
    LoginType loginType = LoginType.facebook;
    try {
      FacebookAuth.instance.login().then((result) async {
        UserCredential userCredential;
        switch (result.status) {
          case LoginStatus.success:
            AuthCredential credential =
                FacebookAuthProvider.credential(result.accessToken!.token);
            userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            final user = userCredential.user;
            return _onAuthSuccess(loginType, user!);
          case LoginStatus.cancelled:
            Log.log.w(result.message);
            throw _onAuthFailed(
                loginType, Exception('Facebook login is cancelled'));
          case LoginStatus.failed:
            Log.log.e(result.message);
            throw _onAuthFailed(
                loginType, Exception('Facebook login is failed'));
          default:
        }
      });
      throw _onAuthFailed(
          loginType, Exception('Facebook login is failed (unkown)'));
    } catch (ex) {
      throw _onAuthFailed(loginType, ex);
    }
  }

  Future<AuthUser> _signInWithApple() async {
    LoginType loginType = LoginType.apple;
    try {
      final nonce = _createNonce(32);
      final nativeAppleCred = Platform.isIOS
          ? await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
                AppleIDAuthorizationScopes.values.first,
                AppleIDAuthorizationScopes.values.last,
              ],
              nonce: sha256.convert(utf8.encode(nonce)).toString(),
            )
          : await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
                AppleIDAuthorizationScopes.values.first,
                AppleIDAuthorizationScopes.values.last,
              ],
              webAuthenticationOptions: WebAuthenticationOptions(
                redirectUri: Uri.parse(Configs.appleRedirectURL),
                clientId: Configs.appleBundleId,
              ),
              nonce: sha256.convert(utf8.encode(nonce)).toString(),
            );

      var credentialsApple = OAuthCredential(
        providerId: 'apple.com',
        signInMethod: 'oauth',
        accessToken: nativeAppleCred.identityToken,
        idToken: nativeAppleCred.identityToken,
        rawNonce: nonce,
      );
      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credentialsApple))
              .user;
      return _onAuthSuccess(loginType, user!);
    } catch (ex) {
      throw _onAuthFailed(loginType, ex);
    }
  }

  Future<AuthUser> _getAuthUser(LoginType loginType, User user) async {
    late LoginType type;
    switch (user.providerData[0].providerId) {
      case 'google.com':
        type = LoginType.google;
        break;
      case 'facebook.com':
        type = LoginType.facebook;
        break;
      case 'apple.com':
        type = LoginType.apple;
        break;
      default:
        type = LoginType.email;
    }
    String idToken = await user.getIdToken();
    return AuthUser(
        id: user.uid,
        name: user.providerData.first.displayName,
        email: user.email,
        emailVerified: user.emailVerified,
        photoURL: user.providerData.first.photoURL,
        idToken: idToken,
        loginType: type);
  }

  Future<AuthUser> refreshAndGetAuthUser(AuthUser authUser, User user) async {
    String idToken = await user.getIdToken();
    authUser.name = user.providerData.first.displayName;
    authUser.photoURL = user.providerData.first.photoURL;
    authUser.idToken = idToken;
    return authUser;
  }

  Future<AuthUser> _onAuthSuccess(LoginType loginType, User user) async {
    AuthUser authUser = await _getAuthUser(loginType, user);
    Log.log.i('Login with ${loginType.toString()} successful');
    Log.log.d(
        'User Data = Name: ${authUser.name}, Email: ${authUser.email}, Email Verified: ${authUser.emailVerified}');
    if (!authUser.emailVerified!) {
      Log.log.i('Sending verification email');
      user.sendEmailVerification();
    }
    return authUser;
  }

  _onAuthFailed(LoginType loginType, Object exception) {
    Log.log.w('Login with ${loginType.toString()} failed');

    if (exception is FirebaseException) {
      Log.log.w(exception.toString());
      return _handleFirebaseException(exception);
    } else if (exception is UserNotFoundExecption) {
      Log.log.w(exception.toString());
      return Exception('User Not Found');
    } else {
      Log.log.w(exception.toString());
      return _handleGenericException(exception);
    }
  }

  _handleFirebaseException(FirebaseException ex) {
    late String message;
    switch (ex.code) {
      case 'user-not-found':
        message = LocaleKeys.authErrors_noUserFound.tr();
        break;
      case 'wrong-password':
        message = LocaleKeys.authErrors_wrongPassword.tr();
        break;
      case 'weak-password':
        message = LocaleKeys.authErrors_weakPassword.tr();
        break;
      case 'email-already-in-use':
        message = LocaleKeys.authErrors_accountAlreadyExist.tr();
        break;
      case 'account-exists-with-different-credential':
        message = LocaleKeys.authErrors_accountExistWithSameEmail.tr();
        break;
      case 'too-many-requests':
        message = LocaleKeys.authErrors_tooManyRequests.tr();
        break;
      case 'unauthorized':
        message = LocaleKeys.authErrors_unauthorized.tr();
        break;
      default:
        message = LocaleKeys.authErrors_signInFailure.tr();
    }
    return Exception(message);
    // ref.read(dialogsProvider).showOKDialog(context,
    //     message: message, title: LocaleKeys.appName.tr());
  }

  _handleGenericException(Object exception) {
    return Exception(exception.toString());
    // ref.read(dialogsProvider).showOKDialog(context,
    //     message: LocaleKeys.authErrors_signInFailure.tr(),
    //     title: LocaleKeys.appName.tr());
  }

  Future<String> _addImageToStorage(String path, File photo) async {
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    await firebaseStorageRef.putFile(photo);
    return await firebaseStorageRef.getDownloadURL();
  }

  String _createNonce(int length) {
    final random = Random();
    final charCodes = List<int>.generate(length, (_) {
      int codeUnit = 0;

      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });

    return String.fromCharCodes(charCodes);
  }
}

typedef OnAuthSuccess = Function(AuthUser user);
typedef OnUserProfileUpdateSuccess = Function(AuthUser user);
typedef OnUserProfileUpdateFailed = Function(Object exception);
typedef OnAuthSuccessAndEmailToVerify = Function(AuthUser user);
typedef OnAuthFailed = Function(Object exception);
typedef OnSignOut = Function();
