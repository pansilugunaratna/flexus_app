// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase_auth_repo.dart';

part '../../../base/generated/lib/extensions/repo/auth/auth_repo.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepo(AuthRepoRef ref) => FirebaseAuthRepo(ref);

abstract class AuthRepo {
  Future<bool> isEmailVerified();
}
