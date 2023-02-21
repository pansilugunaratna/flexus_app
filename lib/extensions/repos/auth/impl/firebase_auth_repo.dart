// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../base/models/auth_user.dart';
import '../../../providers/firebase/auth/provider.dart';
import '../../../providers/firebase/user/provider.dart';
import '../auth_repo.dart';
import '../enums/login_type.dart';

class FirebaseAuthRepo implements AuthRepo {
  FirebaseAuthRepo(this.ref);

  final ProviderRef ref;

  @override
  isEmailVerified() async {
    return await ref.read(firebaseAuthProvider).isEmailVerified();
  }

  @override
  Future<AuthUser> autoSignIn() async {
    return await ref.read(firebaseAuthProvider).autoSignUserIn();
  }

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    return await ref
        .read(firebaseAuthProvider)
        .signInWithEmail(email, password);
  }

  @override
  Future<AuthUser> signInWithSocialLogin(LoginType loginType) async {
    return await ref.read(firebaseAuthProvider).loginWithSocialAuth(loginType);
  }

  @override
  Future<AuthUser> signUpWithEmail(
      String name, String email, String password) async {
    return await ref
        .read(firebaseAuthProvider)
        .signUpWithEmail(name, email, password);
  }

  @override
  Future<void> resetPassword(String email) async {
    await ref.read(firebaseAuthProvider).resetPassword(email);
  }

  @override
  Future<AuthUser> updateUserInfo(LoginType loginType, String? name,
      String? password, File? photo, String? gender) async {
    AuthUser authUser = await ref
        .read(firebaseAuthProvider)
        .updateUserInfo(loginType, name, password, photo);
    await ref.read(firebaseUserProvider).saveAppUser(authUser, gender);
    return authUser;
  }

  @override
  Future<void> signOutFromAll() async {
    return ref.read(firebaseAuthProvider).signOutFromAll();
  }
}
