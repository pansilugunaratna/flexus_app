// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/lib/base/core/user.g.dart';

@Riverpod(keepAlive: true)
class AppUserInfo extends _$AppUserInfo {
  @override
  AppUser build() => AppUser();
}

class AppUser {
  String? gender;

  AppUser({
    this.gender,
  });
}
