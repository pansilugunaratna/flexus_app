// Copyright 2023 Chatura Dilan Perera. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../base/generated/assets/assets.gen.dart';
import '../../base/generated/locale/locale_keys.g.dart';
import '../../configs/logger.dart';
import '../../configs/theme.dart';
import '../../extensions/providers/dialogs/common/provider.dart';
import '../../extensions/providers/firebase/auth/provider.dart';
import '../../extensions/providers/ui/provider.dart';
import '../../extensions/widgets/app_page.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_box.dart';

final _isLoading = StateProvider<bool>((ref) => false);

class ForgotPasswordPage extends ConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiProvider);
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
                Text(LocaleKeys.auth_forgotPassword.tr(),
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: ThemeConfigs.pd4x),
                Text(LocaleKeys.auth_emailToResetPassword.tr()),
                const SizedBox(height: ThemeConfigs.pd2x),
                FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      AuthTextBox(
                          name: 'email',
                          key: const Key('textEmail'),
                          decoration: ui.getAuthInputDecorator(
                            context,
                            LocaleKeys.auth_email.tr(),
                            icon: const Icon(FontAwesomeIcons.at),
                          ),
                          validators: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                            FormBuilderValidators.maxLength(50),
                          ])),
                      const SizedBox(height: ThemeConfigs.pd2x),
                      AuthButton(LocaleKeys.auth_resetPassword.tr(),
                          () => _resetPassword(formKey, context, ref),
                          key: const Key('buttonResetPassword')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

_resetPassword(GlobalKey<FormBuilderState> formKey, BuildContext context,
    WidgetRef ref) async {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  if (formKey.currentState!.validate()) {
    Log.log.i('Sign in form validation success');
    var email = formKey.currentState!.fields['email']?.value;
    ref.read(_isLoading.notifier).state = true;
    await firebaseAuth.resetPassword(context, ref, email, resetSuccess: () {
      ref.read(_isLoading.notifier).state = false;
      ref.read(dialogsProvider).showOKDialog(context,
          message: LocaleKeys.auth_resetPasswordSuccess.tr(),
          title: LocaleKeys.appName.tr(), onOKPressed: () {
        context.pop();
        context.pop();
      });
    }, resetFailed: () {
      ref.read(_isLoading.notifier).state = false;
    });
  }
}
