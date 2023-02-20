// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_type.dart';

part '../../../../base/generated/lib/extensions/repos/auth/classes/auth_user.g.dart';

@Riverpod(keepAlive: true)
class AuthUserInfo extends _$AuthUserInfo {
  @override
  AuthUser build() => AuthUser();
}

class AuthUser {
  AuthUser(
      {this.id,
      this.name,
      this.email,
      this.emailVerified,
      this.provider,
      this.photoURL,
      this.idToken,
      this.loginType});

  String? email;
  bool? emailVerified;
  String? id;
  String? idToken;
  LoginType? loginType;
  String? name;
  String? photoURL;
  String? provider;
}
