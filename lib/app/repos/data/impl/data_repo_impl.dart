// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/posts/posts.dart';
import '../../../data/pb/provider.dart';
import '../data_repo.dart';

class DataRepoImpl implements DataRepo {
  DataRepoImpl(this.ref);

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
