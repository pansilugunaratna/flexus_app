// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../configs/routes.dart';
import '../../extensions/providers/dialogs/common/provider.dart';
import '../../extensions/providers/firebase/analytics/provider.dart';
import '../../extensions/providers/firebase/auth/provider.dart';
import '../../extensions/providers/firebase/user/provider.dart';
import '../../extensions/repos/auth/classes/auth_user.dart';
import '../generated/locale/locale_keys.g.dart';
import '../providers/auth/auth_user_info.dart';
import 'user.dart';

part '../generated/lib/base/core/events.g.dart';

@Riverpod(keepAlive: true)
Events events(EventsRef ref) => Events();

class Events {
  afterSignIn(AuthUser authUser, WidgetRef ref) async {
    ref.read(analyticsProvider).analytics.setUserId(id: authUser.id);
    ref.read(authUserInfoProvider.notifier).state = authUser;
    ref.read(appUserInfoProvider.notifier).state =
        await ref.read(firebaseUserProvider).getAppUser(AppUser(), ref);
  }

  void onSignOut(BuildContext context, WidgetRef ref) {
    ref.read(dialogsProvider).showYesNoDialog(context,
        message: LocaleKeys.auth_signOutConfirmation.tr(),
        title: LocaleKeys.appName.tr(),
        onNoPressed: () => Navigator.of(context).pop(),
        onYesPressed: () {
          Navigator.of(context).pop();
          ref.read(firebaseAuthProvider).signOutFromAll(() {
            ref.invalidate(authUserInfoProvider);
            ref.invalidate(appUserInfoProvider);
            context.go(Routes.splashPage);
          });
        });
  }
}
