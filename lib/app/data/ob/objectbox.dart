// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../../base/generated/objectbox/objectbox.g.dart';
import 'entities/post_entity.dart';

class ObjectBox {
  late Store store;

  Future<void> openOBStore() async {
    store = await openStore();
  }

  List<PostEntity> getPosts() {
    return store.box<PostEntity>().getAll();
  }

  addPost(String quoteId) {
    store.box<PostEntity>().put(PostEntity(description: quoteId));
  }
}
