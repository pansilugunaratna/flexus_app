// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../base/generated/assets/assets.gen.dart';
import '../../base/generated/locale/locale_keys.g.dart';
import '../../base/providers/firebase/analytics/provider.dart';
import '../../base/widgets/app_page.dart';
import '../../configs/routes.dart';
import '../../configs/theme.dart';
import '../auth/widgets/auth_button.dart';

class FrontPage extends ConsumerWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage.safeArea(
        onAnalytics: () =>
            ref.read(analyticsProvider).screen(runtimeType.toString()),
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(ThemeConfigs.defaultAppPadding),
            child: Column(children: [
              Expanded(
                  flex: 3,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Assets.images.app.logoLong.image(
                              width: 30.0.w,
                              cacheWidth: 216,
                              cacheHeight: 85,
                              color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: ThemeConfigs.defaultAppPadding),
                      Assets.images.intro.intro1
                          .image(cacheWidth: 624, cacheHeight: 534),
                    ],
                  ))),
              Expanded(
                  flex: 1,
                  child: Center(
                      child: Column(
                    children: [
                      AuthButton(
                          key: const Key('signInButton'),
                          LocaleKeys.auth_signIn.tr(),
                          () => context.push(Routes.signInPage)),
                      const SizedBox(height: ThemeConfigs.defaultAppPadding),
                      AuthButton(
                          key: const Key('signUpButton'),
                          LocaleKeys.auth_signUp.tr(),
                          () => context.push(Routes.signUpPage)),
                    ],
                  ))),
            ]),
          ),
        ));
  }
}
