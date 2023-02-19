// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../models/posts/posts.dart';
import '../../pb/client.dart';
import 'repo.dart';

class DataRepoImpl implements DataRepo {
  DataRepoImpl(this.ref);

  final DataRepoRef ref;

  @override
  Future<void> initiate() async {
    await ref.read(pbProvider).authenticateUser();
  }

  @override
  Future<Posts> getPosts() async {
    return await ref.read(pbProvider).getPosts();
  }
}
