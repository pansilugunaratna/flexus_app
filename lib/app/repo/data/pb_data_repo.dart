// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/posts/posts.dart';
import '../../pb/client.dart';
import 'data_repo.dart';

class PBDataRepo implements DataRepo {
  PBDataRepo(this.ref);

  final ProviderRef ref;

  @override
  Future<void> initiate() async {
    await ref.read(pbProvider).authenticateUser();
  }

  @override
  Future<Posts> getPosts() async {
    return await ref.read(pbProvider).getPosts();
  }
}
