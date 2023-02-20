// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/posts/posts.dart';
import 'pb_data_repo.dart';

part '../../../base/generated/lib/app/repos/data/repo.g.dart';

@Riverpod(keepAlive: true)
DataRepo dataRepo(DataRepoRef ref) => PBDataRepo(ref);

abstract class DataRepo {
  Future<void> initiate();

  Future<Posts> getPosts();
}
