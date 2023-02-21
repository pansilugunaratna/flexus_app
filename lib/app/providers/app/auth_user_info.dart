import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../base/models/auth_user.dart';

part '../../../base/generated/lib/app/providers/app/auth_user_info.g.dart';

@Riverpod(keepAlive: true)
class AuthUserInfo extends _$AuthUserInfo {
  @override
  AuthUser build() => AuthUser();
}
