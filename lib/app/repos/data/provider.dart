// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data_repo.dart';
import 'impl/data_repo_impl.dart';

part '../../../base/generated/lib/app/repos/data/provider.g.dart';

@Riverpod(keepAlive: true)
DataRepo dataRepo(DataRepoRef ref) => DataRepoImpl(ref);
