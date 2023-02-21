import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repo.dart';
import 'impl/firebase_auth_repo.dart';

part '../../../base/generated/lib/extensions/repos/auth/provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepo(AuthRepoRef ref) => FirebaseAuthRepo(ref);
