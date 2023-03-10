// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/data/models/posts/posts.dart';
import '../../app/repos/data/provider.dart';
import '../../base/generated/locale/locale_keys.g.dart';

final _postsProvider = FutureProvider.autoDispose<Posts>(
    (ref) => ref.read(dataRepoProvider).getPosts());

class PocketBasePage extends ConsumerWidget {
  const PocketBasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.apiPage_menuName.tr())),
      body: Center(
        child: ref.watch(_postsProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (posts) {
                return Text('${posts.items?.last.title}');
              },
            ),
      ),
    );
  }
}
