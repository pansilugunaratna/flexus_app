import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../extensions/repos/auth/classes/auth_user.dart';

part '../../generated/lib/base/providers/auth/auth_user_info.g.dart';

@Riverpod(keepAlive: true)
class AuthUserInfo extends _$AuthUserInfo {
  @override
  AuthUser build() => AuthUser();
}
