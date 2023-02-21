// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../base/generated/assets/assets.gen.dart';
import '../../base/generated/locale/locale_keys.g.dart';
import '../../configs/logger.dart';
import '../../configs/routes.dart';
import '../../configs/theme.dart';
import '../../extensions/providers/dialogs/common/provider.dart';
import '../../extensions/repos/auth/provider.dart';
import '../../extensions/widgets/app_page.dart';
import 'widgets/auth_button.dart';

final _isLoading = StateProvider<bool>((ref) => false);

class EmailConfirmationPage extends ConsumerWidget {
  const EmailConfirmationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    return AppPage.safeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Assets.images.app.logoLong.image(
            cacheWidth: 192,
            width: 96.0,
            color: Theme.of(context).colorScheme.primary),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: ref.watch(_isLoading),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConfigs.defaultAppPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(LocaleKeys.auth_emailVerification.tr(),
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: ThemeConfigs.pd4x),
                Text(LocaleKeys.auth_verifyEmailMessage.tr()),
                const SizedBox(height: ThemeConfigs.pd2x),
                AuthButton(LocaleKeys.auth_iHaveVerifiedMyEmail.tr(),
                    () => _verifyEmail(formKey, context, ref),
                    key: const Key('buttonVerifyEmail')),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

_verifyEmail(
    GlobalKey<FormBuilderState> formKey, BuildContext context, WidgetRef ref) {
  ref.read(_isLoading.notifier).state = true;
  ref.read(authRepoProvider).isEmailVerified().then((isVerified) {
    if (isVerified) {
      ref.read(_isLoading.notifier).state = false;
      ref.read(dialogsProvider).showOKDialog(context,
          message: LocaleKeys.auth_thankYouForVerifyingEmail.tr(),
          title: LocaleKeys.appName.tr(),
          onOKPressed: () => context.go(Routes.splashPage));
    } else {
      ref.read(_isLoading.notifier).state = false;
      Log.log.w('Email is not verified');
      ref.read(dialogsProvider).showOKDialog(context,
          message: LocaleKeys.auth_emailNotVerifiedYet.tr(),
          title: LocaleKeys.appName.tr());
    }
  });
}
