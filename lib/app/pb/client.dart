// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../configs/logger.dart';
import '../../configs/pb.dart';
import '../models/posts/posts.dart';

part '../../base/generated/lib/app/pb/client.g.dart';

@Riverpod(keepAlive: true)
PBClient pb(PbRef ref) {
  return PBClient(PBConfig.baseURL, PBConfig.user, PBConfig.pass);
}

class PBClient {
  final String baseUrl;
  final String user;
  final String pass;
  late PocketBase _pb;
  final postsCollection = 'posts';
  final usersCollection = 'users';

  PBClient(this.baseUrl, this.user, this.pass) {
    _pb = PocketBase(baseUrl);
  }

  authenticateUser() async {
    await _pb.collection(usersCollection).authWithPassword(user, pass);
    // await _pb.admins.authWithPassword(user, pass);
    Log.log.i('Pocketbase User Authenticated');
  }

  Future<Posts> getPosts() async {
    final result = await _pb
        .collection(postsCollection)
        .getList(sort: '-created', perPage: double.maxFinite.toInt());
    return Posts.fromMap(result.toJson());
  }
}
