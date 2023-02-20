// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/routes.dart';
import '../../app/repos/data/repo.dart';
import '../../base/core/events.dart';
import '../../base/generated/assets/assets.gen.dart';
import '../../configs/configs.dart';
import '../../configs/theme.dart';
import '../../extensions/repos/auth/auth_repo.dart';
import '../../extensions/widgets/app_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  Future<void> _initSplash(WidgetRef ref) async {
    await ref.read(dataRepoProvider).initiate();
  }

  _onPageLoad(BuildContext context, WidgetRef ref, int splashScreenDelay) {
    Future.delayed(Duration(seconds: splashScreenDelay), () {
      _initSplash(ref).then((value) {
        ref.read(authRepoProvider).autoSignIn().then((authUser) {
          if (authUser.emailVerified!) {
            ref.read(eventsProvider).afterSignIn(authUser, ref);
            context.go(Routes.homePage);
          } else {
            ref.read(eventsProvider).afterSignIn(authUser, ref);
            context.go(Routes.emailConfirmationPage);
          }
        }).onError((error, stackTrace) {
          context.go(Routes.introPage);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
        onVisible: () => _onPageLoad(context, ref, Configs.splashScreenDelay),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(ThemeConfigs.defaultAppPadding),
            child: Center(
              child: Assets.images.app.logo.image(
                  cacheWidth: 624,
                  color: Theme.of(context).colorScheme.primary),
            ).animate().fadeIn(delay: 1.seconds),
          ),
        ));
  }
}
