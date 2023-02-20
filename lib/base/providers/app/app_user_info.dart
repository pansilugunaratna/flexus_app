import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/app_user.dart';

part '../../generated/lib/base/providers/app/app_user_info.g.dart';

@Riverpod(keepAlive: true)
class AppUserInfo extends _$AppUserInfo {
  @override
  AppUser build() => AppUser();
}
