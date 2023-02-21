// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../models/posts/posts.dart';

abstract class DataRepo {
  Future<void> initiate();

  Future<Posts> getPosts();
}
