// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:io';

import '../../../base/models/auth_user.dart';
import 'enums/login_type.dart';

abstract class AuthRepo {
  Future<bool> isEmailVerified();
  Future<AuthUser> autoSignIn();
  Future<AuthUser> signInWithSocialLogin(LoginType loginType);
  Future<AuthUser> signInWithEmail(String email, String password);
  Future<AuthUser> signUpWithEmail(String name, String email, String password);
  Future<void> resetPassword(String email);
  Future<AuthUser> updateUserInfo(LoginType loginType, String? name,
      String? password, File? photo, String? gender);
  Future<void> signOutFromAll();
}
