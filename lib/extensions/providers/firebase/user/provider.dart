// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app/auth_user_info.dart';
import '../../../../base/models/app_user.dart';
import '../../../../base/models/auth_user.dart';
import '../../../../configs/logger.dart';

part '../../../../base/generated/lib/extensions/providers/firebase/user/provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseUserProvider firebaseUser(FirebaseUserRef ref) =>
    FirebaseUserProvider();

class FirebaseUserProvider {
  final userCollection = 'users';

  Future<void> saveAppUser(AuthUser authUser, String? gender) async {
    var values = <String, dynamic>{};

    if (gender != null) {
      values['gender'] = gender;
    }

    await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(authUser.id)
        .set(values);
  }

  Future<AppUser> getAppUser(AppUser appUser, WidgetRef ref) async {
    final authUser = ref.read(authUserInfoProvider);
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(authUser.id)
          .get();
      if (doc.exists) {
        Log.log.i('App user found');
        appUser.gender =
            doc.data().toString().contains('gender') ? doc.get('gender') : '';
      } else {
        Log.log.w('App user not found');
      }
    } catch (ex) {
      Log.log.e(ex);
    }
    return appUser;
  }
}
