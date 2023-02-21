// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../base/models/auth_user.dart';

part '../../../base/generated/lib/app/providers/app/auth_user_info.g.dart';

@Riverpod(keepAlive: true)
class AuthUserInfo extends _$AuthUserInfo {
  @override
  AuthUser build() => AuthUser();
}
