// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/posts/posts.dart';
import 'data_repo_impl.dart';

part '../../../base/generated/lib/app/repositories/data/repo.g.dart';

@Riverpod(keepAlive: true)
DataRepo dataRepo(DataRepoRef ref) => DataRepoImpl(ref);

abstract class DataRepo {
  Future<void> initiate();

  Future<Posts> getPosts();
}
