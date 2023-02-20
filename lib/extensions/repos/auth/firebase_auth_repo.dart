// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firebase/auth/login_type.dart';
import '../../providers/firebase/auth/models/auth_user.dart';
import '../../providers/firebase/auth/provider.dart';
import 'auth_repo.dart';

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
}
