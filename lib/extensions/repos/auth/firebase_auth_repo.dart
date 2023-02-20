// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firebase/auth/provider.dart';
import 'auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  FirebaseAuthRepo(this.ref);

  final ProviderRef ref;

  @override
  isEmailVerified() async {
    return await ref.read(firebaseAuthProvider).isEmailVerified();
  }
}
