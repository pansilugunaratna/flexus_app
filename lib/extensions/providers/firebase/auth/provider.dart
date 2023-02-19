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

import '../../../../configs/configs.dart';
import '../../../../configs/logger.dart';
import '../../../../base/generated/locale/locale_keys.g.dart';
import '../../dialogs/common/provider.dart';
import 'login_type.dart';
import 'models/auth_user.dart';
import 'user_not_found_exception.dart';

part '../../../../base/generated/lib/extensions/providers/firebase/auth/provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuthProvider firebaseAuth(FirebaseAuthRef ref) =>
    FirebaseAuthProvider();

class FirebaseAuthProvider {
  loginWithSocialAuth(BuildContext context, WidgetRef ref, LoginType loginType,
      {required OnAuthSuccess success,
      required OnAuthSuccessAndEmailToVerify emailToVerify,
      required OnAuthFailed failed}) async {
    Log.log.i('Login with ${loginType.toString()} clicked');
    switch (loginType) {
      case LoginType.facebook:
        await _signInWithFacebook(context, ref, loginType, success, failed);
        break;
      case LoginType.google:
        await _signInWithGoogle(context, ref, loginType, success, failed);
        break;
      case LoginType.apple:
        await _signInWithApple(context, ref, loginType, success, failed);
        break;
      default:
        Log.log.w('Invalid social login type');
    }
  }

  signInWithEmail(
      BuildContext context, WidgetRef ref, String email, String password,
      {required OnAuthSuccess success,
      required OnAuthSuccessAndEmailToVerify emailToVerify,
      required OnAuthFailed failed}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      _onAuthSuccess(LoginType.email, success, emailToVerify, user);
    } on FirebaseAuthException catch (ex) {
      _onAuthFailed(context, ref, LoginType.email, failed, ex);
    } catch (ex) {
      _onAuthFailed(context, ref, LoginType.email, failed, ex);
    }
  }

  signUpWithEmail(BuildContext context, WidgetRef ref, String name,
      String email, String password,
      {required OnAuthSuccess success,
      required OnAuthSuccessAndEmailToVerify emailToVerify,
      required OnAuthFailed failed}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      await user.updateDisplayName(name);
      _onAuthSuccess(LoginType.email, success, emailToVerify, user);
    } on FirebaseAuthException catch (ex) {
      _onAuthFailed(context, ref, LoginType.email, failed, ex);
    } catch (ex) {
      _onAuthFailed(context, ref, LoginType.email, failed, ex);
    }
  }

  autoSignUserIn(BuildContext context, WidgetRef ref,
      {required OnAuthSuccess success,
      required OnAuthSuccessAndEmailToVerify emailToVerify,
      required OnAuthFailed failed}) async {
    try {
      FirebaseAuth.instance.currentUser?.reload();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _onAuthSuccess(LoginType.auto, success, emailToVerify, user);
      } else {
        _onAuthFailed(context, ref, LoginType.auto, failed,
            UserNotFoundExecption('User not found'));
      }
    } catch (ex) {
      _onAuthFailed(context, ref, LoginType.email, failed, ex);
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
      _handleFirebaseException(context, ref, exception);
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
      _handleFirebaseException(context, ref, ex);
      failed(ex);
    } catch (ex) {
      Log.log.w(ex);
      _handleGenericException(context, ref, ex);
      failed(ex);
    }
  }

  _signInWithGoogle(BuildContext context, WidgetRef ref, LoginType loginType,
      OnAuthSuccess onAuthSuccess, OnAuthFailed onAuthFailed) async {
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
      _onAuthSuccess(loginType, onAuthSuccess, null, user!);
    } catch (ex) {
      _onAuthFailed(context, ref, loginType, onAuthFailed, ex);
    }
  }

  _signInWithFacebook(BuildContext context, WidgetRef ref, LoginType loginType,
      OnAuthSuccess onAuthSuccess, OnAuthFailed onAuthFailed) async {
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
            _onAuthSuccess(loginType, onAuthSuccess, null, user!);
            break;
          case LoginStatus.cancelled:
            Log.log.w(result.message);
            _onAuthFailed(context, ref, loginType, onAuthFailed,
                Exception('Facebook login is cancelled'));
            break;
          case LoginStatus.failed:
            Log.log.e(result.message);
            _onAuthFailed(context, ref, loginType, onAuthFailed,
                Exception('Facebook login is failed'));
            break;
          default:
        }
      });
    } catch (ex) {
      _onAuthFailed(context, ref, loginType, onAuthFailed, ex);
    }
  }

  _signInWithApple(BuildContext context, WidgetRef ref, LoginType loginType,
      OnAuthSuccess onAuthSuccess, OnAuthFailed onAuthFailed) async {
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
      _onAuthSuccess(loginType, onAuthSuccess, null, user!);
    } catch (ex) {
      _onAuthFailed(context, ref, loginType, onAuthFailed, ex);
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

  _onAuthSuccess(LoginType loginType, OnAuthSuccess onAuthSuccess,
      OnAuthSuccessAndEmailToVerify? emailToVerify, User user) async {
    AuthUser authUser = await _getAuthUser(loginType, user);
    Log.log.i('Login with ${loginType.toString()} successful');
    Log.log.d(
        'User Data = Name: ${authUser.name}, Email: ${authUser.email}, Email Verified: ${authUser.emailVerified}');

    if (emailToVerify != null) {
      if (user.emailVerified) {
        onAuthSuccess(authUser);
      } else {
        Log.log.i('Sending verification email');
        user.sendEmailVerification();
        emailToVerify(authUser);
      }
    } else {
      onAuthSuccess(authUser);
    }
  }

  _onAuthFailed(BuildContext context, WidgetRef ref, LoginType loginType,
      OnAuthFailed onAuthFailed, Object exception) {
    Log.log.w('Login with ${loginType.toString()} failed');

    if (exception is FirebaseException) {
      Log.log.w(exception.toString());
      _handleFirebaseException(context, ref, exception);
    } else if (exception is UserNotFoundExecption) {
      Log.log.w(exception.toString());
    } else {
      Log.log.w(exception.toString());
      _handleGenericException(context, ref, exception);
    }
    onAuthFailed(exception);
  }

  void _handleFirebaseException(
      BuildContext context, WidgetRef ref, FirebaseException ex) {
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
    ref.read(dialogsProvider).showOKDialog(context,
        message: message, title: LocaleKeys.appName.tr());
  }

  void _handleGenericException(
      BuildContext context, WidgetRef ref, Object exception) {
    ref.read(dialogsProvider).showOKDialog(context,
        message: LocaleKeys.authErrors_signInFailure.tr(),
        title: LocaleKeys.appName.tr());
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
