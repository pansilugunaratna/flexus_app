// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../base/models/auth_user.dart';
import 'enums/login_type.dart';
import 'impl/firebase_auth_repo.dart';

part '../../../base/generated/lib/extensions/repos/auth/auth_repo.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepo(AuthRepoRef ref) => FirebaseAuthRepo(ref);

abstract class AuthRepo {
  Future<bool> isEmailVerified();
  Future<AuthUser> autoSignIn();
  Future<AuthUser> signInWithSocialLogin(LoginType loginType);
  Future<AuthUser> signInWithEmail(String email, String password);
  Future<AuthUser> signUpWithEmail(String name, String email, String password);
  Future<void> resetPassword(String email);
}
