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

import '../../base/core/events.dart';
import '../../base/generated/assets/assets.gen.dart';
import '../../base/generated/locale/locale_keys.g.dart';
import '../../configs/logger.dart';
import '../../configs/routes.dart';
import '../../configs/theme.dart';
import '../../extensions/providers/firebase/analytics/provider.dart';
import '../../extensions/providers/ui/provider.dart';
import '../../extensions/repos/auth/auth_repo.dart';
import '../../extensions/repos/auth/classes/login_type.dart';
import '../../extensions/widgets/app_page.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_text_box.dart';
import 'widgets/social_auth_button.dart';

final _isLoading = StateProvider<bool>((ref) => false);

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(uiProvider);
    final formKey = GlobalKey<FormBuilderState>();
    return AppPage.safeArea(
        onAnalytics: () =>
            ref.read(analyticsProvider).screen(runtimeType.toString()),
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
                    Text(LocaleKeys.auth_signUp.tr(),
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: ThemeConfigs.pd4x),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        SocialAuthButton(
                            LoginType.google, _signUpWithSocialAuth),
                        SocialAuthButton(
                          LoginType.facebook,
                          _signUpWithSocialAuth,
                        ),
                        SocialAuthButton(
                          LoginType.apple,
                          _signUpWithSocialAuth,
                        )
                      ],
                    ),
                    const SizedBox(height: ThemeConfigs.pd2x),
                    Text(LocaleKeys.auth_orRegisterWithEmail.tr()),
                    const SizedBox(height: ThemeConfigs.pd2x),
                    FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          AuthTextBox(
                              name: 'name',
                              decoration: ui.getAuthInputDecorator(
                                context,
                                LocaleKeys.auth_name.tr(),
                                icon: const Icon(FontAwesomeIcons.user),
                              ),
                              validators: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(50),
                              ])),
                          AuthTextBox(
                              name: 'email',
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
                          AuthTextBox(
                              name: 'password',
                              obscureText: true,
                              decoration: ui.getAuthInputDecorator(
                                context,
                                LocaleKeys.auth_password.tr(),
                                icon: const Icon(FontAwesomeIcons.key),
                              ),
                              validators: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.minLength(8),
                              ])),
                          AuthTextBox(
                              name: 'confirmPassword',
                              obscureText: true,
                              decoration: ui.getAuthInputDecorator(
                                context,
                                LocaleKeys.auth_confirmPassword.tr(),
                                icon: const Icon(FontAwesomeIcons.key),
                              ),
                              validators: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.maxLength(50),
                                FormBuilderValidators.minLength(8),
                                (val) {
                                  if (formKey.currentState!.fields['password']
                                          ?.value !=
                                      val) {
                                    return LocaleKeys
                                        .auth_confirmPasswordNotMatching
                                        .tr();
                                  }
                                  return null;
                                }
                              ])),
                          const SizedBox(height: ThemeConfigs.pd2x),
                          AuthButton(LocaleKeys.auth_signUp.tr(),
                              () => _signUpWithButton(formKey, context, ref),
                              key: const Key('buttonSignUp')),
                          const SizedBox(height: ThemeConfigs.pd4x),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(LocaleKeys.auth_alreadyHaveAnAccount.tr()),
                              const SizedBox(width: ThemeConfigs.pd_25x),
                              InkWell(
                                child: Text(LocaleKeys.auth_signIn.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                onTap: () => context.go(Routes.signInPage),
                              )
                            ],
                          )
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

_signUpWithSocialAuth(
    LoginType loginType, BuildContext context, WidgetRef ref) {
  final events = ref.read(eventsProvider);
  ref.read(_isLoading.notifier).state = true;

  ref.read(authRepoProvider).signInWithSocialLogin(loginType).then((authUser) {
    if (authUser.emailVerified!) {
      ref.read(_isLoading.notifier).state = false;
      events.afterSignIn(authUser, ref);
      context.go(Routes.homePage);
    } else {
      ref.read(_isLoading.notifier).state = false;
      events.afterSignIn(authUser, ref);
      context.push(Routes.emailConfirmationPage);
    }
  }).onError((error, stackTrace) {
    ref.read(_isLoading.notifier).state = false;
    //TODO: Show error dialog
  });
}

_signUpWithButton(
    GlobalKey<FormBuilderState> formKey, BuildContext context, WidgetRef ref) {
  final events = ref.read(eventsProvider);

  Log.log.i('Sign up form clicked');
  if (formKey.currentState!.validate()) {
    Log.log.i('Sign up form validation success');
    var name = formKey.currentState!.fields['name']?.value;
    var email = formKey.currentState!.fields['email']?.value;
    var password = formKey.currentState!.fields['password']?.value;
    ref.read(_isLoading.notifier).state = true;

    ref
        .read(authRepoProvider)
        .signUpWithEmail(name, email, password)
        .then((authUser) {
      if (authUser.emailVerified!) {
        ref.read(_isLoading.notifier).state = false;
        events.afterSignIn(authUser, ref);
        context.go(Routes.homePage);
      } else {
        ref.read(_isLoading.notifier).state = false;
        events.afterSignIn(authUser, ref);
        context.push(Routes.emailConfirmationPage);
      }
    }).onError((error, stackTrace) {
      ref.read(_isLoading.notifier).state = false;
      //TODO: Show error dialog
    });
  } else {
    Log.log.w('Sign up form validation failed');
  }
}
